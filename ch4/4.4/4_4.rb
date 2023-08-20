# instance_eval
# オブジェクトのコンテキストでブロックを評価する BasicObject#instance_eval

class MyClass
  def initialize
    @v = 1
  end
end

obj = MyClass.new

obj.instance_eval do
  p self #<MyClass:0x0000000100f30100 @v=1>
  p @v # 1
end

# instance_eval に渡したブロックは、レシーバをselfにしてから評価されるので、
# レシーバの privateメソッド や @vなどのインスタンス変数 にもアクセスできる。
# また他のブロックと同じように、instance_evalを定義したときの束縛も見える。

# 以下の3行はフラットスコープで評価される。　そのため、いずれもローカル変数 v にアクセスできる。
# また、ブロックはself となるオブジェクトのコンテキストでも評価されるため、objのインスタンス変数である @v にもアクセスできる。

v = 2
obj.instance_eval { @v = v }
obj.instance_eval { p @v } # -> 2

# instance_eval に渡したブロックのことを 「コンテキスト探索機」 と呼ぶ。
# オブジェクトの内部を探索して、そこで何かを実行するコードだからだ。

# instance_eval は、ブロックに引数を取れない。
# instance_eval は、self となるオブジェクトで評価されるため。

class C
  def initialize
    @x = 1
  end
end

class D
  def twisted_method
    @y = 2
    # C.new.instance_eval { p "@x: #{@x}, @y: #{@y}" } # -> "@x: 1, @y: "　----　@y は self(C.new)にあると期待するが、ないのでnilと判断し、空文字。
    C.new.instance_exec(@y) { |y| p "@x: #{@x}, @y: #{y}" } # -> "@x: 1, @y: 2"　----　@y を引数として渡すことでき、その値を使うことができる
  end
end

D.new.twisted_method