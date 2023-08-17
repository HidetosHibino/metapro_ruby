# Refinements

module StringExtensions
  refine String do
    def to_alphanumeric
      gsub(/[^\w\s]/, '')
    end
  end
end

# 通常のオープンクラスと異なり、Refinementsはそのままでは使えない。
# 実行結果：undefined method `to_alphanumeric' for "my *1st refinement!":String (NoMethodError)
# p 'my *1st refinement!'.to_alphanumeric

# 変更を反映するためには、usingメソッドを使って明示的に有効にする必要がある。
using StringExtensions
p 'my *1st refinement!'.to_alphanumeric
