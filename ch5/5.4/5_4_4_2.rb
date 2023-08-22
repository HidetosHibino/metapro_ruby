# クラスのアトリビュート

class MyClass
  attr_accessor :a
end

obj = MyClass.new
obj.a = 2
p obj.a # -> 2

# ここにクラスに対して、アトリビュートを追加したい。

# classを再オープンした場合。
class Class
  attr_accessor :b
end

MyClass.b = 42
p MyClass.b # -> 42

# これでは「すべてのクラス」にアトリビュートが追加されてしまう。
class OtherMyClass; end
p OtherMyClass.b

# MyClassにだけアトリビュートを追加するためには、また別の方法が必要である。

# 特異クラスにアトリビュートを追加する。
class MyClass
  class << self
    attr_accessor :c
  end
end

MyClass.c = 'It works!'
p MyClass.c

# 以下は undefined method `c=' for OtherMyClass:Class (NoMethodError)
# p OtherMyClass.c = "It doesn't works!"
