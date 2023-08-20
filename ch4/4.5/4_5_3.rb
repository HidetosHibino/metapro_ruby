# Methodオブジェクト

class MyClass
  def initialize(value)
    @x = value
  end

  def my_method
    @x
  end
end

obj = MyClass.new(1)
m = obj.method :my_method
# p m #<Method: MyClass#my_method() 4_5_3.rb:6>
p m.call

# Object#method を呼び出すと。メソッドそのものをmethodオブジェクトとして取得できる。
# このオブジェクトは後でMethod#call　を使って実行できる。

# Methodは Method#to_proc で Procに変換できる。
# ブロックは define_method でメソッドに変換できる。
# method は 所属するオブジェクトのスコープで評価される。

# UnboundMethod
# UnboundMethod は元のクラスやモジュールから引き離されたメソッド
# Method を UnboundMethodに変換するには、 Method#unbind を呼び出す。
# 以下の例のように Method#instance_method を呼び出せば、直接UnboundMethodを取得することができる。

module MyModule
  def my_method
    42
  end
end

unbound = MyModule.instance_method(:my_method)
p unbound.class # -> UnboundMethod

# UnboundMethodを呼び出すことはできないが、そこから通常のメソッドを生成することができる。
# そのためには、 UnboundMethod#bind を使い、unboundMethodをオブジェクトに束縛する。
# ただし、UnboundMethodは元のクラスと同じクラス（またはサブクラス）のオブジェクトしか束縛できない。
# Module#difine_methodに渡すことでもできる。

String.send :define_method, :another_method, unbound

p 'abc'.another_method # -> 42

# 動的メソッドをつかってString の define_method を呼び出しているのは、これがprivateメソッドだからである。
