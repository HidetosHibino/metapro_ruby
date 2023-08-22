# Module によって クラスメソッドを定義したい。

module MyModule
  def self.my_method; 'Hello'; end

  def method_in_module; end
end

class MyClass
  include MyModule
end

p MyClass.my_method # -> undefined method `my_method' for MyClass:Class (NoMethodError)

# クラスがモジュールをインクルードすると、モジュールのインスタンスメソッドが手に入る。
# クラスメソッドはもっと外にいる。モジュールの特異メソッドの中にある
# つまり、self.my_method　は モジュール：MyModule の特異メソッドにあるっぽい

# obj = MyClass.new
# obj.method_in_module
