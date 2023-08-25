# Railsの最初のバージョンにおけるアトリビュートレコード

module ActiveRecord #:nodoc:
  class Base
    class << self # Class methods 特異クラス

      public
        # New objects can be instantiated as either empty (pass no construction parameter) or pre-set with
        # attributes but not yet saved (pass a hash with key names matching the associated table column names).
        # In both instances, valid attribute keys are determined by the column names of the associated table -- 
        # hence you can't have attributes that aren't part of the table columns.
        def initialize(attributes = nil)
          @attributes = attributes_from_column_definition
          @new_record = true
          ensure_proper_type
          self.attributes = attributes unless attributes.nil?
          yield self if block_given?
        end

        def attribute_names
          @attributes.keys.sort
        end

        alias_method :respond_to_without_attributes?, :respond_to?

        def respond_to?(method)
          @@dynamic_methods ||= attribute_names + attribute_names.collect { |attr| attr + "=" } + attribute_names.collect { |attr| attr + "?" }
          @@dynamic_methods.include?(method.to_s) ? true : respond_to_without_attributes?(method)
        end

      private
        def method_missing(method_id, *arguments)
          method_name = method_id.id2name
        
          if method_name =~ read_method? && @attributes.include?($1) # =~ は正規表現におけるマッチ
            return read_attribute($1)
          elsif method_name =~ write_method?
            write_attribute($1, arguments[0])
          elsif method_name =~ query_method?
            return query_attribute($1)
          else
            super
          end
        end

        def read_method?()  /^([a-zA-Z][-_\w]*)[^=?]*$/ end
        def write_method?() /^([a-zA-Z][-_\w]*)=.*$/    end
        def query_method?() /^([a-zA-Z][-_\w]*)\?$/     end

        def read_attribute(attr_name) #:doc:
          if column = column_for_attribute(attr_name)
            @attributes[attr_name] = unserializable_attribute?(attr_name, column) ?
              unserialize_attribute(attr_name) : column.type_cast(@attributes[attr_name])
          end
          
          @attributes[attr_name]
        end

        def write_attribute(attr_name, value) #:doc:
          @attributes[attr_name] = empty_string_for_number_column?(attr_name, value) ? nil : value
        end

        def query_attribute(attr_name)
          attribute = @attributes[attr_name]
          if attribute.kind_of?(Fixnum) && attribute == 0
            false
          elsif attribute.kind_of?(String) && attribute == "0"
            false
          elsif attribute.kind_of?(String) && attribute.empty?
            false
          elsif attribute.nil?
            false
          elsif attribute == false
            false
          elsif attribute == "f"
            false
          elsif attribute == "false"
            false
          else
            true
          end
        end
    end
  end
end

# initialize メソッドでは、ActiveRecord::Baseオブジェクトを生成すると、インスタンス変数に@attributesにデータベースのカラム名が入る。
# method_missingでは、アトリビュートの名前がゴーストメソッドの名前になっている。
# description= のようなメソッドを呼び出すと、method_missingは2つのことを確認する。
# 一つはdescriptionがアトリビュートの名前であること。もう一つは、description= が書き込み用のアクセサの正規表現にマッチすること（method_name =~ write_method? ）
# その結果は method_missing はwrite_attribute を呼び出す。 (write_attribute)
# これは description の値をデータベースに書き込むメソッドだ。
# 問い合わせのアクセサ（最後がクエスチョンマークのもの）や読み取り用のアクセサも同じような処理になる。

# ゴーストメソッドを使う場合は respond_to? も再定義する必要があり、以下のように再定義
# def respond_to?(method)
#   @@dynamic_methods ||= attribute_names + attribute_names.collect { |attr| attr + "=" } + attribute_names.collect { |attr| attr + "?" }
#   @@dynamic_methods.include?(method.to_s) ? true : respond_to_without_attributes?(method)
# end

# さらにアラウンドエイリアスでもある。
# alias_method :respond_to_without_attributes?, :respond_to?
# respond_to の2行目で実行 @@dynamic_methods.include?(method.to_s) ? true : respond_to_without_attributes?(method)

