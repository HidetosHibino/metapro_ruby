# メソッド探索
# Rubyはオブジェクトのクラスを探索してメソッドを探索している
# レシーバ：呼び出すメソッドが属するオブジェクト
# my_string.reverse の場合は my_string
# 継承チェーン：クラスからスーパークラスに移動する。それからそのスーパークラスを想像する。
# それをクラス階層のルートであるBasicObjectまで続ける。

class MyClass
  def my_method
    'my_method()'
  end
end

class MySubclass < MyClass
end

obj = MySubclass.new
p obj.my_method # -> "my_method()"

# この場合
# obj の クラス（MySubclass）からスーパークラスを辿っていく
# MyClassでmy_method が見つかる
# method は クラスと紐づいてるんでしたね

# クラスの継承チェーンは ancestorsメソッドで確認できる。
# p MySubclass.ancestors # -> [MySubclass, MyClass, Object, Kernel, BasicObject]
# p Class.instance_methods.grep(/an/)

# モジュールとメソッド探索
# 継承チェーンにはモジュールも含まれる。
# モジュールをクラスにインクルードすると、Rubyはモジュールを継承チェーンに挿入する。
# それはインクルードするクラスの真上に入る。

module M1
  def my_method
    'M1#my_method()'
  end
end

class C
  include M1
end

class D < C; end

p D.ancestors # -> [D, C, M1, Object, Kernel, BasicObject]

# prepend では下にモジュールが追加される。

module M2
  def my_method
    'M1#my_method()'
  end
end

class C2
  prepend M2
end

class D2 < C2; end

p D2.ancestors # -> [D2, M1, C2, Object, Kernel, BasicObject]