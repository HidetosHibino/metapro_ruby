# アラウンドエイリアス
# Module#alias_method を使えば Ruby のメソッドにエイリアス(別名)をつけることができる。

class MyClass
  def my_method; 'my_method()'; end
  alias_method :m, :my_method
end

obj = MyClass.new
p obj.my_method # -> "my_method()"
p obj.m # -> "my_method()"

# alias_method を使うときは、メソッドの新しい名前を先、メソッドの元の名前を後に書く。名前はシンボルか文字列で渡す。

# メソッドにエイリアスをつけて、再定義すると何が起こるだろうか？

class String
  alias_method :real_length, :length

  def length
    real_length > 5 ? 'long' : 'short'
  end
  # alias_method :real_length, :length # こちらで宣言すると循環参照でエラー `length': stack level too deep (SystemStackError)
end

p 'War and Peace'.length # -> "long"
p 'War and Peace'.real_length # -> 13

# alias_method :real_length, :length は、既存のlength を参照して、別名をつけている。
# 一方で、'War and Peace'.length は再定義したメソッドを参照している。

# メソッドの再定義は、元のメソッドを変更するのではなく、
# 新しいメソッドを作成して、元のメソッドの名前をつけてること。

# ある種、元のメソッドに別名（エイリアス）を付与して、逃しておき、再定義しているという捉え方ができるかも、、、

