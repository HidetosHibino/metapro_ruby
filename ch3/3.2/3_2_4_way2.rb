# メソッドを動的に生成する。
# クラス定義の中でdefine_methodが複数回呼び出されている。
# ここでは当該クラス（今回はTodayDatetimer）が暗黙的にselfになっている。

class TodayDatetimer
  def initialize
    @today = Time.now
  end

  def self.define_component(name)
    #このdefine_method は自身のクラスに対して実行される(self = TodayDatetimer)。
    define_method(name) do
      # テキストではDB接続のためのクラスを使うが、ここではTimeオブジェクトとそれのメソッドで代用
      "#{name}: #{@today.send name}"
    end
  end

  define_component :year
  define_component :month
  define_component :day
end

today = TodayDatetimer.new
# p today.class.instance_methods(false) #　ここには既に「:month, :year, :day」は存在する。まあ当たり前
p today.year
p today.month
p today.day
