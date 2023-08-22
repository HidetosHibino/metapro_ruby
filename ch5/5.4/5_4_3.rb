# メソッド探索のおさらい

class C
  def a_method
    'C#a_method()'
  end
end

class D < C; end

obj = D.new
p obj.a_method # -> 'C#a_method()'

# p obj.singleton_class # -> #<Class:#<D:0x00000001044f0308>>

class << obj
  def a_singleton_method
    'obj#a_singleton_method()'
  end
end

# 特異クラスはクラスである。つまり、スーパークラスがあるはず。
# 特異クラスのスーパークラスは何か？
p obj.singleton_class.superclass

# obj の特異クラスのスーパークラスはDである。

# つまり、こうなる
#       object
#         ↑
#         C
#         ↑
#         D
#         ↑
# obj -> #obj (#a_singleton_method)

# オブジェクトが特異メソッドを持っていれば、Rubyは通常のクラスではなく、特異のメソッドから探索を始める。
