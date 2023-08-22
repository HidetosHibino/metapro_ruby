str = 'just a regular string'

def str.title?
  self.upcase == self
end

p str.title? # -> false
p str.methods.grep(/title?/) # -> [:title?]
p str.singleton_methods # -> [:title?]

# 上記のコードは文字列strに title?メソッドを追加している。
# String クラスの他のオブジェクトに影響はない

# この様に単一のオブジェクトに特化したメソッドを「特異メソッド」とよぶ。
# 特異メソッドは、上記構文もしくは、 Object#define_singleton_method で定義できる。
