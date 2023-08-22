# カレントクラス

# Ruby のプログラムは常に可憐とオブジェクト self を持っている。
# それと同様に、常にカレントクラス（あるいはカレントモジュール）を持っている。
# メソッドを定義すると、それはカレントクタスのインスタンスメソッドになる。

# カレントオブジェクトはself で参照を獲得できるが、カレントクラスを獲得するキーワードはない。
# カレントクラスを追跡するにはコードをみればいい

# ・プログラムのトップレベルでは、カレントクラスは main のクラスのObjectになる。 (mainはObjectクラスのインスタンス)
# ・classキーワードでクラス（あるいはmoduleキーワードでモジュール）をオープンすると、そのクラスがカレントクラスになる。
# ・メソッドの中では、カレントオブジェクトのクラスがカレントクラスになる。以下のコードを参照

class C
  def m1 
    def m2; end
  end
end

class D < C; end

p C.instance_methods(false) # -> [:m1]
# obj.m2 # -> undefined local variable or method `obj' for main:Object (NameError)

obj = D.new
obj.m1

p C.instance_methods(false) # -> [:m1, :m2]
obj.m2 # -> No Error

# 2番目のケース

# カレントクラスを変更するためには、classキーワード以外の方法が必要。
# class_eval を使う必要がある。 # -> 4_5_3_active_support

# Module#class_eval はそこにあるクラスのコンテキストでブロックを評価する。

def add_method_to(a_class)
  p "#{self}: self@add_method" # -> "main: self@add_method"
  a_class.class_eval do
    p "#{self}: self@a_class.class_eval" # -> "String: self@a_class.class_eval"
    # ここでは、self だけでなく、カレントクラスも変わっている。
    def m; 'Hello' end
  end
end

add_method_to String
p 'abc'.m # -> "Hello"

# クラス以外をオープンしたいなら、instance_eval
# クラス定義をオープンして、def を使ってメソッドを定義したいならclass_eval を使う。

# Ruby のインタープリタは常にカレントクラス（あるいはカレントモジュール）の参照を追加している。
# def で定義されたメソッドはカレントクラスのインスタンスメソッドになる。

# クラス定義の中では、カレントオブジェクト self カレントクラス（定義しているクラス）は同じである。

# クラスへの参照を持っていれば、クラスは class_eval(あるいはmodule_eval)でオープンできる。
