# フックメソッド
# 以下のプログラムは、クラスがStringwo継承したときに、その通知を画面に印字するものだ。

class String
  def self.inherited(subclass)
    puts "#{self}は#{subclass}に継承された。"
  end
end

class MyString < String; end # -> StringはMyStringに継承された。

# inherited メソッドは class のインスタンスメソッドである。
# クラスが継承されたときに Ruby が呼び出してくれる。
# Class#inherited はデフォルトでは何もしないので、自分のコードでオーバーライドして使う必要がある。

# Class inheritedのようなメソッドは、特定のイベントにフックをかけることから「フックメソッド」と呼ばれる。