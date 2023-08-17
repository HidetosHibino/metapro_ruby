class MyClass
  def my_method
    @v = 1
  end
end

obj = MyClass.new
# 以下はMyClass
p obj.class

obj.my_method

# インスタンス変数の確認 ->[:@v]
p obj.instance_variables

# #############################################
# # インスタンス変数は値が代入されたときに初めて出現する。
# # なので、my_method実行前後ではインスタンス変数は異なる。
# test_ins_var = MyClass.new
# p test_ins_var.instance_variables # -> []
# test_ins_var.my_method
# p test_ins_var.instance_variables # -> [:@v]
# #############################################

# メソッドの確認
# -> Object#methods　を呼び出す。
# 特定のものにしたければ、Array#grep　を使う
p obj.methods

# インスタンス変数はオブジェクトにある。
# メソッドはクラスにある。
# インスタンスはクラスへの参照を持っている。
