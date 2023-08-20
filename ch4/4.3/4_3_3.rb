# スコープのフラット化

my_var = '成功'

# class MyClass
#   # my_var　を使いたい
#   def my_method
#     # my_var　を使いたい
#   end
# end

# class のスコープゲートを通り抜ける。
# メソッド呼び出しで、classをスコープゲートでない何かに置き換える。

# class と同じ効果のあるメソッドは Class.new
# ブロックをClass.newに渡せば、クラスにインスタンスメソッドを定義できる。

MyClass = Class.new do
  # この中ではmy_varを使用できる。
  puts "クラス定義の中は#{my_var}"

  # def my_method
  #   # my_var　を使いたい
  # end
end

# def のスコープゲートを通り抜ける。
# def ではなく、メソッド呼び出しにする。

# メソッドを定義するためのメソッドを呼び出すので、 define_method を使用する。

# MyClass　は クラスclassのオブジェクトなので、そいつにdefine_method

MyClass.define_method :my_method do
  puts "メソッド定義の中も#{my_var}"
end

obj = MyClass.new
obj.my_method

p obj.class.instance_methods(false) # => [:my_method]

# スコープゲートをメソッド呼び出しに変えると、他のスコープの変数が見えるようになる。
# この作法を「入れ子構造のレキシカルスコープ」と呼ぶ。
# スコープのフラット化・フラットスコープともいう

