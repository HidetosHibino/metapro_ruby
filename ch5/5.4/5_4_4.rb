# クラスと特異クラスとスーパークラスの繋がりを見る。

class C
  class << self
    def a_class_method
      'C.a_class_method()'
    end
  end
end

class D < C; end

p C.singleton_class # -> #<Class:C>
p D.singleton_class # -> #<Class:D>
p C.singleton_class.superclass # -> #<Class:Object>
p D.singleton_class.superclass # -> #<Class:C>

p D.a_class_method

s1, s2 = "abc", "def"
s1.instance_eval do
  def swoosh!; reverse; end
end

p s1.swoosh! # -> "cba"
p s2.respond_to? :swoosh! # -> false

p s1.singleton_class.instance_methods.grep(/swoosh/) # -> [:swoosh!]
p s2.singleton_class.instance_methods.grep(/swoosh/) # -> []

# instance_eval では、レシーバを特異クラスに変えていることがわかる。