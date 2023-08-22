# Module#include や module#prepend をオーバーライドすれば、
# モジュールのライフサイクルにプラグインできる。

module M1
  def self.included(othermod)
    puts "#{self}は#{othermod}にインクルードされた。"
  end
end

module M2
  def self.prepended(othermod)
    puts "#{self}は#{othermod}にプリペンドされた。"
  end
end

class C
  include M1
  prepend M2
end

p C.ancestors # -> [M2, C, M1, Object, Kernel, BasicObject]

# module#extended をオーバーライドすれば、モジュールがオブジェクトを拡張したときにコードを実行できる。
# module#method_added, method_removed, method_undifined をオーバーライドすれば、メソッドに関連したイベントを実行できる。

module M
  def self.method_added(method)
    puts "新しいメソッド:#{self}##{method}"
  end

  def my_method; end
end

# これらのフックはオブジェクトのクラスにすむインスタンスメソッドにしか使えない。
# オブジェクトの特異クラスにすむ特異メソッドでは動作しないのである。
# 特異メソッドのイベントをキャッチするには、
# Kernel#singleton_method_added、Kernel#singleton_method_removed、Kernel#singleton_method_undifinedを使う
