class MyClass
  def testing_self
    @var = 10
    my_method
    self
  end

  def my_method
    @var = @var + 1
  end
end

# obj = MyClass.new
# p obj.testing_self

# testing_selfを呼び出すと、レシーバーであるobjがselfとなる。
# その結果、インスタンス変数 @var は objのインスタンス変数となり、
# レシーバーを明示していない my_method メソッドの呼び出しも obj に対するものとなる

module M1
  p self # クラスやモジュール定義の内側(メソッドの外側)では、selfはクラスやモジュールそのものになる。　-> M1
  def testing_self
    @var = 10
    my_method
    self
  end
end

class MyClass2
  include M1
  def my_method
    @var = @var + 1
  end
end

obj2 = MyClass2.new
p obj2.testing_self # -> #<MyClass2:0x00000001025d6b48 @var=11>
