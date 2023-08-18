class MyClass
  def my_method(my_arg)
    my_arg * 2
  end
end

obj = MyClass.new
# p obj.my_method 3

# ドット記法を使わず、Object#send を使ってMyClass #my_method　を呼び出す方法がある
p obj.send(:my_method, 3)

# sendを使うと、呼び出したいメソッド名が通常の引数になり、コードの実行時に呼び出すメソッドを決めることができる。
# これを「動的ディスパッチ」と呼ぶ
