# my_method を MyModule の普通のインスタンスメソッドとして定義して、
# MyClass の特異クラスで、モジュールをインクルードする。

module MyModule
  def my_method; 'Hello'; end
end

class MyClass
  class << self
    include MyModule
  end 
end

p MyClass.my_method # -> "Hello"

# my_method は MyClass の特異クラスのインスタンスメソッドである。
# つまり、my_method は MyClass のクラスメソッドである。
# この技法はクラス拡張と呼ばれる。

# クラスメソッドとinclude
# クラス拡張を使ってクラスの特異クラスにメソッドを定義すれば、それはクラスメソッドになる。
# クラスメソッドは特異クラスの特殊ケースに過ぎないので、このトリックはどんなオブジェクトにも適用できる。

# 普通のオブジェクトに適用した場合、これは「オブジェクト拡張」とおバレル。

obj = Object.new
class << obj
  include MyModule
end

p obj.my_method # -> "Hello"
p obj.singleton_methods # -> [:my_method]

# クラスを再オープンするのは一般的ではない。
# Object#extend
# クラス拡張と、オブジェクト拡張は Ruby がそのためだけにメソッドを提供されている。

obj2 = Object.new
p obj2.singleton_methods # -> [] 確認

obj2.extend MyModule
p obj2.my_method # -> "Hello"
p obj2.singleton_methods # -> [:my_method]

class MyClass2
  extend MyModule
end

p MyClass2.my_method # -> "Hello"
p MyClass2.singleton_methods # -> [:my_method]

Object#extend はレシーバの特異クラスにモジュールをインクルードするためのショートカットである。
