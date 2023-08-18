# Module#define_method を使えば、メソッドをその場で定義できる。
# それにはメソッド名とブロックを渡す必要があ理。ブロックがメソッドの本体となる。

class MyClass
  define_method :my_method do |my_args|
    my_args * 3
  end
end

obj = MyClass.new
p obj.my_method(2) # -> 6

# my_method は MyClassのインスタンスメソッドとして定義される
# 実行時にメソッドを定義する方法は「動的メソッド」と呼ばれる
