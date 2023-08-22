# オブジェクトは裏に特別なクラスを持っている。
# 特異クラスと呼ばれる。(メタクラス/シングルトンクラス)とも呼ばれる。

# object#class などのメソッドは特異クラスを丁寧に隠してしまう。
# class キーワードを使った特別な構文で、特異クラスのスコープを覗ける。

# class << an_object
#   # code here
# end

# 特異クラスの参照を獲得したければ、スコープの外にself を返せばよい
obj = Object.new

sample_singleton_class = class << obj
  self # p self -> #<Class:#<Object:0x0000000104cb5368>>
end

p sample_singleton_class.class # -> class

# p "abc".class # -> String

# p "abc".singleton_class # -> #<Class:#<String:0x0000000100dd7358>>

# 以下は同じ
p obj.singleton_class
p sample_singleton_class

# 特異クラスは Objrct#singleton_class か、class << という構文を使わなければ見ることができない。
# 特異クラスは インスタンスを1つしか持てない
# 特異クラスはオブジェうとの特異メソッドが住んでいる場所である

def obj.singleton_XXXXXXX_method; end
# 以下に singleton_XXXXXXX_method が含まれていることを確認
p sample_singleton_class.instance_methods.grep(/XXXXXXX/) # ->[:singleton_XXXXXXX_method]
