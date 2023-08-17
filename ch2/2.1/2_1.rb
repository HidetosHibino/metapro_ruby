# POINT
# Rubyでは実行中にclass定義を再オープンすることができる
# 以下はString classに to_alphanumeric メソッドを追加している。

# この段階ではStringクラスは変更されていないので、以下のエラー
# undefined method `to_alphanumeric' for "$100_test~~":String (NoMethodError)

# p "$100_test~~".to_alphanumeric

class String
  def to_alphanumeric
    gsub(/[^\w\s]/, "")
  end
end

# こっちは成功する。　=> "100_test"
p '$100_test~~'.to_alphanumeric
