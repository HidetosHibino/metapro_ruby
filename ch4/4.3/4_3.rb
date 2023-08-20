def my_method
  x = 'GoodBye'
  yield('cruel')
end

x = 'Hello'
p my_method { |y| "#{x}, #{y} world" } # -> "Hello, cruel world"

# x は 'hello'
# ブロックが定義されたときのxを見ている。
# これは、メソッドにある束縛はブロックから見えないから

# ブロックを作成すると、それ自体の束縛ができる。これはローカルの束縛である。
# メソッドにも束縛がある。これはメソッドレベルでの束縛である。

# ブロックの中で、新たな束縛を定義することができる。
# ただし、ブロックが終了した時点で消滅する。

def just_yield
  yield
end

top_level_variable = 1

just_yield do
  top_level_variable += 1
  local_to_block = 1 #新しい束縛
end

p top_level_variable # -> 2
# p local_to_block # -> undefined local variable or method `local_to_block' for main:Object (NameError)
