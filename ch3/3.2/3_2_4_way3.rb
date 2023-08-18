# メソッドを動的に生成する。
# define_component の呼び出しをもっと機械的にする
# 今回はTimeクラスオブジェクトの持つメソッドのうち、'mon'で始まるもののみを抽出し、メソッド化
# @today.methods.grep(/^mon/)　で抽出して、結果をブロックで回す。

class TodayDatetimer
  def initialize
    @today = Time.now
    # p @today.methods.grep(/^mon/) -> [:mon, :month, :monday?]
    @today.methods.grep(/^mon/) { |x| TodayDatetimer.define_component x }
  end

  def self.define_component(name)
    #このdefine_method は自身のクラスに対して実行される(self = TodayDatetimer)。
    define_method(name) do
      # テキストではDB接続のためのクラスを使うが、ここではTimeオブジェクトとそれのメソッドで代用
      "#{name}: #{@today.send name}"
    end
  end
end

today = TodayDatetimer.new
# p today.class.instance_methods(false) #　ここには既に「:month, :year, :day」は存在する。まあ当たり前
p today.month
p today.monday?
p today.mon
