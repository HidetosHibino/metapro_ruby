# Refinements の有効範囲

# Refinements はモジュール定義の終わりまで有効になる。

module StringExtensions
  refine String do
    def reverse
      'esrever'
    end
  end
end

module StringStuff
  using StringExtensions
  p 'my_string'.reverse # -> "esrever"
  # def rtn_str
  #   'rtn_str'.reverse
  # end
end

p 'my_string'.reverse # -> "gnirts_ym"

# class HasRefi
#   include StringStuff
#   # def check
#   #   p 'my_string'.reverse # -> "gnirts_ym"
#   #   p rtn_str # -> "esrever"
#   # end
# end

# has_refi = HasRefi.new
# has_refi.check

# Refinementsの上書き範囲
# トップレベル(using使用)のレベルでは上書きされているが、それ以外のレベルでは上書きされない？

class MyClass
  def my_method
    'original my_method'
  end

  def another_method
    my_method
  end
end

module MyClassRefinements
  refine MyClass do
    def my_method
      'refined my_method'
    end
  end
end

using MyClassRefinements
p MyClass.new.my_method
p MyClass.new.another_method