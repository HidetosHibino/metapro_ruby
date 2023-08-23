# Concern::extended のメソッド
# gem unpack activesupport
# ch10/activesupport-7.0.4.3/lib/active_support/concern.rb

module ActiveSupport
  module Concern
    class MultipleIncludedBlocks < StandardError # :nodoc:
      def initialize
        super "Cannot define multiple 'included' blocks for a Concern"
      end
    end

    def self.extended(base) # :nodoc:
      base.instance_variable_set(:@_dependencies, [])
    end

    # ...
  end
end

# モジュールがConcern をエクステンドすると、Rubyがフックメソッドであるextended を呼び出す。
# そして、エクステンダーにクラスインスタンス変数である、 @_dependencies を定義する。

# Modue#append_features
# Modue#append_featuresは Rubyのコアのメソッドである。
# モジュールをインクルードしたときにRubyが呼び出すという意味では、Module#included と似ている。
# だが、append_features と included には重大な違いがある。
# included はフックメソッドなので、通常はメソッドの中身がなく、オーバーライドして使うものだ。
# 一方、append_features は実際にインクルードするものだ。
# インクルードされたモジュールがインクルーダーの継承チェーンに含まれているかどうかを確認して、含まれていなければ、継承チェーンにモジュールを追加する。

module M
  def self.append_features(base); end
end

# module T; end

class C
  include M
  # include T
end

p C.ancestors # -> [C, Object, Kernel, BasicObject] もしくは　[C, T, Object, Kernel, BasicObject]

# 上記のコードが示すように、append_features をオーバーライドすると、モジュールが一切インクルードされなくなる。

# Concern#append_features
# Concern は独自のappend_features を定義している。

module ActiveSupport
  module Concern
    def append_features(base) # :nodoc:
      if base.instance_variable_defined?(:@_dependencies)
        base.instance_variable_get(:@_dependencies) << self
        false
      else
        return false if base < self
        @_dependencies.each { |dep| base.include(dep) }
        super
        base.extend const_get(:ClassMethods) if const_defined?(:ClassMethods)
        base.class_eval(&@_included_block) if instance_variable_defined?(:@_included_block)
      end
    end
  end
end

# append_features はConcernのインスタンスメソッドである。
# 従って、Concern をエクステンドしたモジュールのクラスメソッドとなる。
# 例えば、Validations というモジュールがConcern をエクステンドすれば、Validations.append_featuresというクラスメソッドが手に入る。

# Cocern#append_featuresの中身

module ActiveSupport
  module Concern
    def append_features(base) # :nodoc:
      if base.instance_variable_defined?(:@_dependencies)
        base.instance_variable_get(:@_dependencies) << self
        false
      else
        return false if base < self
        @_dependencies.each { |dep| base.include(dep) }
        super
        base.extend const_get(:ClassMethods) if const_defined?(:ClassMethods)
        base.class_eval(&@_included_block) if instance_variable_defined?(:@_included_block)
      end
    end
  end
end

# concern の中で、concernをインクルードしないようにしている。


# ###########################################
# https://docs.ruby-lang.org/ja/latest/method/Module/i/=3c.html
# 注意：モジュールの比較演算子としての 「 < 」
# self < other -> bool | nil[permalink][rdoc][edit]
# 比較演算子。self が other の子孫である場合、 true を返します。 self が other の先祖か同一のクラス／モジュールである場合、false を返します。
# 継承関係にないクラス同士の比較では nil を返します。
# ###########################################

# class A
#   def initialize
#      @name = ['init_name']
#   end
#  end
#  a = A.new
#  p a.instance_variable_get(:@name) # -> ["init_name"]
#  a.instance_variable_get(:@name) << 'update_name'
#  p a.instance_variable_get(:@name) # -> ["init_name", "update_name"]

