# プログラムがスコープを切り替えて、新しいスコープをオープンする場所は３つある。
# ・クラス定義
# ・モジュール定義
# ・メソッド
# それぞれ　class module def これらは　「スコープゲート」として振る舞う。

v1 = 1

class MyClass 
  v2 = 2
  p "point1: #{local_variables}"

  def my_method
    v3 = 3
    "point2: #{local_variables}"
  end

  p "point3: #{local_variables}"
end

obj = MyClass.new
p "point4: #{obj.my_method}"
p "point5: #{obj.my_method}"
p "point6: #{local_variables}"

