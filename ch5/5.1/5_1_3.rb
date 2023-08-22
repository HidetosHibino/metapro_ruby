# クラスインスタンス変数
# Ruby のインタプリタは、すべてのインスタンス変数はカレントオブジェクト self に属していると思っている。
# これはクラス定義でも同様だ。

class MyClass
  @my_var = 1
end

# クラス定義の中では、self はクラス自身のこと。 なので、@my_varはクラスに属している。
# クラスのインスタンス変数と、クラスオブジェクトのインスタンス変数は別物。

$check_self_flg = false

class MyClass
  p "#{self}: self@MyClass" if $check_self_flg # -> "MyClass: self@MyClass"
  @my_var = 1

  def self.read
    p "#{self}: self@self.read" if $check_self_flg # -> "MyClass: self@self.read"
    @my_var
  end

  def write
    p "#{self}: self@write" if $check_self_flg # -> "#<MyClass:0x0000000100a2e9b8>: self@write"
    @my_var = 2
  end

  def read
    p "#{self}: self@read" if $check_self_flg # -> "#<MyClass:0x0000000100a2e9b8>: self@read"
    @my_var
  end
end

obj = MyClass.new
# p obj.instance_variables # -> []
# p MyClass.instance_variables # -> [:@my_var]

p obj.read # -> nil
obj.write
p obj.read # -> 2
p MyClass.read # -> 1

# p obj.instance_variables # -> [:@my_var]
# p MyClass.instance_variables # -> [:@my_var]

# 上記のコードでは、2つのインスタンス変数を定義している。
# どちらも同じ @my_var という名前だ。
# それぞれ異なるスコープで定義されており、別々のオブジェクトに属している。
# 1つ目の@my_varは objがselfとなる場所に定義されている。 -> objオブジェクトのインスタンス変数
# 2つ目の@my_barは MyClassがselfとなる場所に定義されている。 -> MyClassというオブジェクトのインスタンス変数 (クラスインスタンス変数)
# ->クラスインスタンス変数 は アクセスできるのはクラスだけであり、クラスのインスタンスやサブクラスからはアクセスできない


# Ruby でも @@ でクラス変数を使うことができる。
# クラス変数はクラスインスタンス変数とは異なり、サブクラスや通常のインスタンスメソッドからアクセスできる。

class C
  @@v = "@@v in class C"
end

class D < C
  def my_method; @@v; end
end

obj = D.new
p obj.my_method # => "@@v in class C"

# # 注意点
# # 簡単にアクセスできてしまうので注意

# @@main_v = "main" # class variable access from toplevel になるので、実行できない

# class E
#   @@main_v = "updated_E"
# end

# p @@main_v # -> "updated_E"
