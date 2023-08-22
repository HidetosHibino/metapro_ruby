module ExplicintString
  def length
    super > 5 ? 'long' : 'short'
  end
end

String.class_eval do
  prepend ExplicintString
end

p String.ancestors # -> [ExplicintString, String, Comparable, Object, Kernel, BasicObject]

p 'War and Peace'.length # -> "long"

# これを 「prependラッパー」という。
# Refinementsラッパーよりも明示的で綺麗な方法だとされる。