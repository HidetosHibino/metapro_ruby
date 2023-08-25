# 存在しないメソッドを呼び出すと、Ruby は継承チェーンを上ってメソッドチェーンを探しに行く。
# 最終的に、BasicObject に到着し、そこでもメソッドが見つからなければ、一番下まで戻ってmethod_missingを呼び出す。
# つまり一般的に ゴーズとメソッドの呼び出しは、少なくとも1回継承チェーンを上る必要があるので、通常のメソッドの呼び出しよりも遅い。

# Railsでの ゴーストメソッドの削除

# activerecord-2.3.2/lib/active_record/attribute_methods.rb

module ActiveRecord
  module AttributeMethods #:nodoc:

    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s

      if self.class.private_method_defined?(method_name)
        raise NoMethodError.new("Attempt to call private method", method_name, args)
      end

      # If we haven't generated any methods yet, generate them, then
      # see if we've created the method we're looking for.
      if !self.class.generated_methods?
        self.class.define_attribute_methods
        if self.class.generated_methods.include?(method_name)
          return self.send(method_id, *args, &block)
        end
      end
      
      if self.class.primary_key.to_s == method_name
        id
      elsif md = self.class.match_attribute_method?(method_name)
        attribute_name, method_type = md.pre_match, md.to_s
        if @attributes.include?(attribute_name)
          __send__("attribute#{method_type}", attribute_name, *args, &block)
        else
          super
        end
      elsif @attributes.include?(method_name)
        read_attribute(method_name)
      else
        super
      end
    end

    def read_attribute(attr_name)
      attr_name = attr_name.to_s
      if !(value = @attributes[attr_name]).nil?
        if column = column_for_attribute(attr_name)
          if unserializable_attribute?(attr_name, column)
            unserialize_attribute(attr_name)
          else
            column.type_cast(value)
          end
        else
          value
        end
      else
        nil
      end
    end

    def write_attribute(attr_name, value)
      attr_name = attr_name.to_s
      @attributes_cache.delete(attr_name)
      if (column = column_for_attribute(attr_name)) && column.number?
        @attributes[attr_name] = convert_number_column_value(value)
      else
        @attributes[attr_name] = value
      end
    end

    def query_attribute(attr_name)
      unless value = read_attribute(attr_name)
        false
      else
        column = self.class.columns_hash[attr_name]
        if column.nil?
          if Numeric === value || value !~ /[^0-9]/
            !value.to_i.zero?
          else
            return false if ActiveRecord::ConnectionAdapters::Column::FALSE_VALUES.include?(value)
            !value.blank?
          end
        elsif column.number?
          !value.zero?
        else
          !value.blank?
        end
      end
    end
  end
end

# Task#description= のようなメソッドを最初に呼び出すと、method_missing が呼び出される。
# 処理を開始する前に、method_missingは、private メソッドを不注意に呼び出してカプセル化を回避しようとしていないかを確認する。
# その後、define_attribute_methodsメソッドを呼び出される。
# define_attribute_methodsメソッドはデータベースにあるすべてのカラムの読み取り・書き込み・問い合わせ用の動的メソッドを定義している。

# データベースのカラムにマップされた description= などのアクセサを2回目以降に呼び出すと、method_missingを経由せずに、実態のあるゴーストメソッドではないメソッドを呼び出す。

module ActiveRecord
  module AttributeMethods #:nodoc:
    module ClassMethods
      # Generates all the attribute related methods for columns in the database
      # accessors, mutators and query methods.
      def define_attribute_methods
        return if generated_methods?
        columns_hash.each do |name, column|
          unless instance_method_already_implemented?(name)
            if self.serialized_attributes[name]
              define_read_method_for_serialized_attribute(name)
            elsif create_time_zone_conversion_attribute?(name, column)
              define_read_method_for_time_zone_conversion(name)
            else
              define_read_method(name.to_sym, name, column)
            end
          end

          unless instance_method_already_implemented?("#{name}=")
            if create_time_zone_conversion_attribute?(name, column)
              define_write_method_for_time_zone_conversion(name)
            else  
              define_write_method(name.to_sym)
            end
          end

          unless instance_method_already_implemented?("#{name}?")
            define_question_method(name)
          end
        end
      end
    end
  end
end

# instance_method_already_implemented は意図しないモンキーパッチを避けるためにある。
# アトリビュートの名前のメソッドがすでに存在していれば、次のアトリビュートにスキップする。
# 実際にメソッドを作るのは、define_read_method/define_write_methodとうに移譲されている。

module ActiveRecord
  module AttributeMethods #:nodoc:
    module ClassMethods
      def define_write_method(attr_name)
        evaluate_attribute_method attr_name, "def #{attr_name}=(new_value);write_attribute('#{attr_name}', new_value);end", "#{attr_name}="
      end

      def evaluate_attribute_method(attr_name, method_definition, method_name=attr_name)

        unless method_name.to_s == primary_key.to_s
          generated_methods << method_name
        end

        begin
          class_eval(method_definition, __FILE__, __LINE__) # class_eval は文字列を受け取れる。その場合は文字列を評価する。
        rescue SyntaxError => err
          generated_methods.delete(attr_name)
          if logger
            logger.warn "Exception occurred during reader method compilation."
            logger.warn "Maybe #{attr_name} is not a valid Ruby identifier?"
            logger.warn err.message
          end
        end
      end
    end
  end
end

# define_write_method メソッドは、class_eval で評価するコード文字列を生成している。
# 例えば、description= を呼び出すと、 evaluate_attribute_methodがそのコード文字列を評価する。

# def description=(new_value);write_attribute('description', new_value);end
# これで、description= メソッドが誕生する。

# 動的なままのアトリビュート
# ActiveRecordがアトリビュートアクセサを定義したくない場面もある。
# 例えば、バックにデータベースのカラムのない派生フィールドのようなアトリビュートを考える。

my_query = "tasks.*, (description like '%garage%') as heavy_job"
# task = Task.find(:first, :select => my_query)
# 昔は find(:first, option) というのができたみたい
# https://guides.rubyonrails.org/v2.3.8/active_record_querying.html#:~:text=Model.find(%3A-,first,-%2C%20options)%20is
# https://guides.rubyonrails.org/v2.3.8/active_record_querying.html#:~:text=Client.all(%3Aselect%20%3D%3E%20%22viewable_by%2C%20locked%22)
# 今風ならこう
task = Task.select(my_query).first
# select で select句を指定する。
task.heavy_job? # -> true

# heavy_job のようなアトリビュートはオブジェクトごとに異なる。
# 従って、それらにアクセスする動的メソッドを生成しても意味がない。
# method_missing の後半はこうしたアトリビュートを扱っている。

if self.class.primary_key.to_s == method_name
  id
elsif md = self.class.match_attribute_method?(method_name)
  attribute_name, method_type = md.pre_match, md.to_s
  if @attributes.include?(attribute_name)
    __send__("attribute#{method_type}", attribute_name, *args, &block)
  else
    super
  end
elsif @attributes.include?(method_name)
  read_attribute(method_name)
else
  super
end

# Handle *? for method_missing.
def attribute?(attribute_name)
  query_attribute(attribute_name)
end

# Handle *= for method_missing.
def attribute=(attribute_name, value)
  write_attribute(attribute_name, value)
end

