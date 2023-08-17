# 最初段階では class D は定義されていない。
# Rubyが class D と x メソッドの定義の中に入ったときに、初めてクラスを定義する。

class D
  def x
    'X'
  end
end

# 2回目のclassの段階では、すでにそのクラスは存在しているので、Rubyは改めてクラスを定義する必要はない。
# その代わり既存のクラスを再オープンして、y メソッドを追加する。

class D
  def y
    'y'
  end
end

obj_d = D.new
p obj_d.x
p obj_d.y

# いつでも既存のクラスを再オープンして、その場で修正できる。
# これの技法をオープンクラス という
