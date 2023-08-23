# Validations モジュール
# ActiveRecord::Base は、 ActiveRecord::Validations という名前のモジュールをインクルードしている。
# このモジュールに valid? や validate メソッドが定義されているように感じる。

# 確かに ActiveRecord::Validationsには valid? が定義されている。しかし validate は定義されていない。

module ActiveRecord
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    def valid?(context = nil)
      context ||= default_validation_context
      output = super(context)
      errors.empty? && output
    end

    # alias_method :validate, :valid?
    # これは ActiveRecord::Validations内で使うエイリアスっぽい

# validate はどこにあるのだろうか？その答えは ActiveModel::Validations で見つかる。
# これは、ActiveRecord::Validations がインクルードしたモジュールだ。
# ActiveModelは ActiveRecordが依存しているライブラリであり、これはそこに含まれるモジュールである。

module ActiveModel
  module Validations
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming
      extend ActiveModel::Callbacks
      extend ActiveModel::Translation

      extend  HelperMethods
      include HelperMethods

      attr_accessor :validation_context
      private :validation_context=
      define_callbacks :validate, scope: :name

      class_attribute :_validators, instance_writer: false, default: Hash.new { |h, k| h[k] = [] }
    end

    module ClassMethods
      def validate(*args, &block)
        options = args.extract_options!

        if args.all?(Symbol)
          options.each_key do |k|
            unless VALID_OPTIONS_FOR_VALIDATE.include?(k)
              raise ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{VALID_OPTIONS_FOR_VALIDATE.map(&:inspect).join(', ')}. Perhaps you meant to call `validates` instead of `validate`?")
            end
          end
        end

        if options.key?(:on)
          options = options.dup
          options[:on] = Array(options[:on])
          options[:if] = [
            ->(o) { !(options[:on] & Array(o.validation_context)).empty? },
            *options[:if]
          ]
        end

        set_callback(:validate, *args, options, &block)
      end


# クラスがモジュールをインクルーそすると、通常はインスタンスメソッドになる。
# （つまり、そのインスタンスメソッドを使おうとすると、 ActiveRecord::Base.new しないといけない。）
# validate は ActiveRecord::Base のクラスメソッドである。 
  # class A << ActiveRecord::Base
  #   validate :name のようにできるのはクラスメソッドだからだよね。
  # end
# これについては１０章
