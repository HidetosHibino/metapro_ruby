# 特異メソッドの謎

class MyClass
  def my_method
    'MyClass#my_method'
  end
end

obj = MyClass.new
p obj.my_method # -> "MyClass#my_method"

# 上記で 特異メソッドを定義するとどうなるか？

def obj.my_singleton_method
  'obj.my_singleton_method'
end

# def obj.my_method
#   'obj.my_method'
# end

# p obj.my_method # -> "obj.my_method"

# この時、obj.my_singleton_method はどこに定義されている？
# obj のインスタンスメソッドは、そのobjのクラスに定義されている。
p obj.class.instance_methods.grep(/^my/) # -> [:my_method]
