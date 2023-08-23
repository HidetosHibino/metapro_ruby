# gem unpack activerecord -v=2.3.2

module ActiveRecord
  module Validations
    VALIDATIONS = %w( validate validate_on_create validate_on_update )

    def self.included(base) # :nodoc:
      base.extend ClassMethods
      base.class_eval do
        alias_method_chain :save, :validation
        alias_method_chain :save!, :validation
      end

      base.send :include, ActiveSupport::Callbacks
      base.define_callbacks *VALIDATIONS
    end

    module ClassMethods
      def validates_length_of(*attrs)
        # 略
      end
    end

    def valid?
      errors.clear

      run_callbacks(:validate)
      validate

      if new_record?
        run_callbacks(:validate_on_create)
        validate_on_create
      else
        run_callbacks(:validate_on_update)
        validate_on_update
      end

      errors.empty?
    end
  end
end

# ActiveRecord::Base が Validations をinclude すると、以下のことが起きる。
# 1.Validations のインスタンスメソッド(valid?) などが、Base クラスのインスタンスメソッドとなる。
# 2.Ruby がActiveRecord::Base を引数にして、Validationsの include というフックメソッドを呼ぶ。
# 3.フックメソッドの中で、Base クラスをActiveRecord::Validations::ClassMethods モジュールでエクステンドしている。
# これはクラス拡張なので、ClassMethodsのメソッドはBase のクラスメソッドとなる。

# その結果、Baseは valid? などのインスタンスメソッドと、validations_length_of などのクラスメソッドの両方を手に入れる。

# ActiveRecord::Baseで以下ではダメなのか？
# include Validates
# extend Validations::ClassMethods

# こうすれば、ActiveRecord::Validations で self.included で extend しなくて済むのでは？
