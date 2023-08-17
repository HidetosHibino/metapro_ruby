# Rubyでは「クラスはオブジェクト」である
p 'hello'.class # -> String
p 'hello'.class.class # => Class

# Javaのような言語では、Classクラスのインスタンスは、そのクラスの情報を読み取るだけである。
# RubyののClassクラスのインスタンスは、クラスそのもので、他のオブジェクトのように操作できる。

# オブジェクトのメソッドはそのクラスのインスタンスメソッド
# ゆえに、クラスのメソッドはClassクラスのインスタンスメソッドである

# false は「継承したメソッドは無視せよ」の意
p Class.instance_methods(false) # -> [:allocate, :superclass, :subclasses, :new]

# superclass メソッドについて
# Rubyのクラスは スーパークラスを継承している。

p Array.superclass # -> Object
p Object.superclass # -> BasicObject
p BasicObject.superclass # -> nil

# Class クラスのスーパークラスは何か？
p Class.superclass # -> Module
# ClassのスーパークラスはModule。
# ゆえに全てのクラスはモジュールである。

# ######一旦確認########
# # 1.個々のクラス（String,Array,ユーザー定義クラス, etc）はClassクラスのインスタンス
# class UserDefine; end
# # 以下は全て Class
# p String.class
# p Array.class
# p UserDefine.class

# # 2.個々のクラス（String,Array,ユーザー定義クラス, etc）はスーパークラスを継承している。(Rubyのクラスは スーパークラスを継承している。)
# class UserDefine; end
# # 以下は全て Object ゆえに「Stringはオブジェクトである」と言える。（その他のそれぞれについても同様）
# p String.superclass
# p Array.superclass
# p UserDefine.superclass

# # 3.ClassのスーパークラスはModule。ゆえに全てのクラスはモジュールである。
# # ClassのスーパークラスはModule。
# p Class.superclass # -> Module
# # 全てのクラスはモジュールである
# class UserDefine; end
# # 以下は全てModule
# p String.class.superclass
# p Array.class.superclass
# p UserDefine.class.superclass

# ※クラスはオブジェクトの生成やクラスを継承するためのインスタンスメソッドを追加したモジュール
# [:allocate, :superclass, :new]

# my_classと MyClassはどちらもClassクラスへの参照である。
# 両者の違いはmy_classは変数であり、MyClassは定数であること。
# つまり、クラスはオブジェクトであり、クラス名は定数であるということ.
