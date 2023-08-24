# alias_method_chain を使う理由

module Greetings
  def greet
    'hello'
  end
end

class MyClass
  include Greetings
end

p MyClass.new.greet # -> "hello"

# greet の周囲に機能を追加したい。
# アラウンドエイリアスを複数使えば、それが実現できる

class MyClass
  include Greetings

  def greet_with_enthusiam
    "Hey, #{greet_without_enthusiam}!"
  end

  alias_method :greet_without_enthusiam, :greet
  alias_method :greet, :greet_with_enthusiam
end

p MyClass.new.greet # -> "Hey, hello!"
p MyClass.new.greet_without_enthusiam # -> "hello"

