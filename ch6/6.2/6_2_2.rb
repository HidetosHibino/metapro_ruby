# # Binding オブジェクト

# bindingは スコープをオブジェクトにまとめたもの。
# Binding を作ってローカルスコープを取得すれば、そのスコープをもち回すことができる。
# eval と一緒に組み合わせて使えば、後からそのスコープでコードを実行することができる。

class MyClass
  def my_method
    @x = 1

    binding
  end
end

p b = MyClass.new.my_method

# Binding オブジェクトには、スコープが含まれているが、コードは含まれていない。
# ブロックよりも「純粋な」クロージャとして考えることができる。取得したコードを評価するためには、
# eval の引数に binding を渡せばよい

p eval "@x", b # -> 1

p eval "@x = 2", b # -> 2

# Ruby にはあらかじめ定義された定数 TOPLEVEL_BINDING が用意されている。
# トップレベルのスコープのbinding になっている。
# これを使えば、どこからでもトップレベルのスコープにアクセスできる。

class AnotherClass
  def my_method
    eval 'self', TOPLEVEL_BINDING
  end
end

p AnotherClass.new.my_method # -> main

# pry の例
# pry ではオブジェクトのスコープでインタラクティブセッションを開く Object#pry メソッドが定義されている。
# 現在の binding の pryを呼び出す行をコードに追加する。

# コード
require 'pry'; binding.pry
# コード

# binding.pry を呼び出すと、現在の bindingで Rubyのインタプリタが開かれる。つまり、実行中のプロセスの中。
# そこから自由に変数を呼んだり変更することができる。
