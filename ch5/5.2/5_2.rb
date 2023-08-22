# class MyClass < Array
#   def my_method
#     'Hello!'
#   end
# end

c = Class.new(Array) do
  def my_method
    'Hello!'
  end
end

# 上記で、クラスを参照する変数ができた。
# まだこのクラスは無名である。

obj = c.new
p obj.class # -> #<Class:0x0000000104c404a0>
p c.name # -> nil

# クラス名は定数なので、自分で割り当てることもできる。
MyClass = c

p obj.class # -> MyClass
p c.name #-> "MyClass"

# 定数に無名クラスを割り当てるとき、Rubyはクラス名をつけようとしていることを理解して、
# クラスに名前を当てはめてくれる
