# 別のモジュールでインクルード＆オーバーライドした方がいいのでは？

module Greetings
  def greet
   'hello'
  end
end

# こうではなく。。。
# class MyClass
#   include Greetings

#   def greet_with_enthusiam
#     "Hey, #{greet_without_enthusiam}!"
#   end

#   alias_method :greet_without_enthusiam, :greet
#   alias_method :greet, :greet_with_enthusiam
# end

# 別のモジュールで、Greetings をインクルードして、オーバーライド、super呼び出し。
# そいつをインクルードする。

module EnthsiasticGreetings
  include Greetings

  def greet
    "Hey, #{super}!"
  end
end

class MyClass
  include EnthsiasticGreetings
end

p MyClass.ancestors[0..2] # -> [MyClass, EnthsiasticGreetings, Greetings]
p MyClass.new.greet # -> "Hey, hello!"
