# ブロックの使用は2つのプロセスに分けられる。
# まずコードを保管する。 (波括弧 or do end)
# それから、そのブロックを( yeild を使って)呼び出して実行する

# この「コードを保管しておいて、後で呼び出す」方式はブロックだけに限らない。

# ・Proc の中
# ・lambda の中
# ・メソッドの中

# Proc オブジェクト
# Ruby では、ほぼ全てがオブジェクトであるが、ブロックは違う。
# そのため、ブロックを保管して、後で実行するためには、（一時的にブロックを保持しておくための）オブジェクトが必要である。

# そのために、RubyではProcクラスが用意されている。
# Procはブロックをオブジェクトにしたものである。
# Proc を作成するためには、 Proc.new にブロックを渡す。
# Proc を使用するためには、Proc#call を呼び出す。

inc = Proc.new { |x| x + 1 }
# ブロックを保持
p inc.call(2) # -> 3

# 矢印ラムダを用いることもできる。
l = ->(x) { x + 1 }
p l.call(2) # -> 3

# 矢印なしなら以下のようになる。
l2 = lambda { |x| x + 1 }
p l2.call(2) # -> 3

# &修飾
# ブロックはメソッドに渡す無名関数のようなもの。通常はメソッドの中で yield を使って実行する。
# だが、yield では足りないケースがある
# ・他のメソッドにブロックを渡したいとき。
# ・ブロックを Proc に渡したいとき。

# いずれの場合も、ブロックを差して、「このブロックを使用したい」と明示する必要がある。
# そのためには指し示す名前が必要である。
# ブロックに束縛を割り当てるには、メソッドに特別な引数を追加する。
# 引数列の最後において、名前の前に&をつける。

def math(a, b)
  yield(a, b)
end

def do_math(a, b, &operation)
  math(a, b, &operation)
end

p do_math(2, 3) { |x, y| x * y } # -> 6

# 変数operationは Procオブジェクトとして扱われている。

def my_method2(&the_proc)
  the_proc
end

p = my_method2 { |name| "Hello #{name}!"}
p p.class # -> Proc
p p.call('Bill') # -> "Hello Bill!"

# Procをブロックに戻す場合は &を使う

def my_method3(greeting)
  "#{greeting} #{yield}"
end

proc = proc { 'Bill' }
p my_method3('Hello', &proc)

# def my_method_test(greeting, a, b)
#   "#{greeting} #{yield(a, b)}"
# end

# proc = proc { |x, y| x * y }
# p my_method_test('result', 3, 4, &proc)

# ブロック/Proc は手続きをまとまりとして扱うためのものっていう理解。
