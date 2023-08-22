# VCRの例

# VCRのRequest クラスは、Normalizers::Body をinclude している。

# Module VCR
# class Request < Struct.new(:method, :uri, :body, :headers)
#   include Normalizers::Header
#   include Normalizers::Body


# BodyモジュールはHTTPメッセージボディを扱う body_formなどのメソッドを定義している。
# モジュールをインクルードすると、これらのメソッドが、Request クラスのメソッドとなる。
# つまり、Requestが Normalizers::Body をインクルードすることにより、クラスメソッドを手に入れた。

# 通常はクラスがモジュールをインクルードすると、インスタンスメソッドが追加される。（クラスメソッドではない。）
# どのようにクラスメソッドとしてインクルードしているか?

# module VCR
#   # @private
#   module Normalizers
#     module Body
#       def self.included(klass)
#         klass.extend ClassMethods
#       end

#       # @private
#       module ClassMethods
#         def body_from(hash_or_string)

    module Body
      def self.included(klass)
        klass.extend ClassMethods
      end
      # @private
      module ClassMethods
        def body_from(hash_or_string)
  
# BodyにはClassMethods という名前の内部クラスがあり、そこにbody_from などの通常のインスタンスメソッドが定義されている。
# それから Body には included というフックメソッドがあり、Request がBody をインクルードすると一連のイベントがトリガーされる。

# Ruby がbody のincluded フックを呼び出す。
# フックがRequest に戻り、ClassMethods モジュールをエクステンドする。
# extend メソッドが、ClassMethods のメソッドを Requestの特異クラスにインクルードする
