# class MyClass
#   def my_attribute=(value)
#     @my_attribute = value
#   end

#   def my_attribute
#     @my_attribute
#   end
# end

# obj = MyClass.new
# obj.my_attribute = 'x'
# p obj.my_attribute

# Module#attr_* を使うと、上記の記載を省略できる。

class MyClass
  attr_accessor :my_attribute
end

obj = MyClass.new
obj.my_attribute = 'x'
p obj.my_attribute

p obj.class.class.superclass # -> Module
# -> MyClass.class.superclass
# -> Class.superclass

# attr_*族のメソッドはModuleクラスで定義されているので、selfがモジュールであってもクラスであっても使える。
# attr_accessor の様なメソッドを クラスマクロ という。
# クラス定義の中で使える、単なるクラスメソッド