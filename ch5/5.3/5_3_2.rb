# クラスメソッドは特異メソッドである。

# オブジェクトの呼び出し。
an_object.a_method

# クラスメソッドの呼び出し。
AClass.a_class_method

# それぞれを特異メソッドとして宣言してみる。

def an_object.a_method
  # do something
end

def AClass.a_class_method
  # do something
end

# 特異メソッドを def を使って定義する方法は
def object.method
  # do something
end

# 上記の object の部分には、オブジェクトの参照/クラス名の定数/self　のいずれかが入る。
