class MyClass
  puts 'Hello'
end

result = class MyClass2
  self
end

p result # -> MyClass2

# クラス定義の中では、クラスがカレントオブジェクトself になる。