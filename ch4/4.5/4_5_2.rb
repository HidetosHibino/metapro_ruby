# Proc と lambda の違い

# 1 return キーワードの違い。
# lambda は単に lambda から戻る

def double(callable_object)
  callable_object.call * 2
end

l = lambda { return 10 }
p double(l)

def another_double
  p = proc { return 10 }
  result = p.call
  return result * 2
end

p another_double

# def another_double_2(&proc)
#   result = proc.call
#   p "is this string logged ?" # -> これは実行されない。 ただし、lambda {　return 10　}　にすると実行される。
#   return result * 2
# end

# pr = proc { return 10 }
# p another_double_2(&pr) # ここで、main からも return されているっぽい(proc { return10 })　なので、以降の処理はされない。
# p "check"

# def another_double_2(proc)
#   result = proc.call
#   p "is this string logged ?" # -> これは実行されない。 ただし、lambda {　return 10　}　にすると実行される。
#   return result * 2
# end

# pr = proc { return 10 }
# p another_double_2(pr)

# 以下はmain から抜けてしまう。 procでreturn しているから
# def double_error(callable_object)
#   callable_object.call * 2
# end

# pr = proc { return 100 }
# p double_error(pr) 

# 以下はmain から抜けない proc でreturn していないから。
def double_error(callable_object)
  callable_object.call * 2
end

pr = proc { 100 }
p double_error(pr)

# proc よりも lambda の方が引数の扱いに厳しい。
pr = proc { |x, y| [x, y] }
p pr.arity # -> 2

p pr.call(1, 2, 3) # -> [1, 2]
p pr.call(1) # -> [1, nil]

# 違った項目数でlambda を呼び出すと、ArgumentError となる。
