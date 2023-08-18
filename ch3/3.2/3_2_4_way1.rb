# 動的ディスパッチを追加する。
# 各メソッドの呼び出しはcomponent に委譲される。
# テキストではcomponent がDB接続し、結果を取得・表示を行っている。
# こちらでは、項目ごとに　def 項目名と component :項目名　が必要

class TodayDatetimer
  def initialize
    @today = Time.now
  end

  def year
    component :year
  end

  def month
    component :month
  end

  def day
    component :day
  end

  def component(name)
    # テキストではDB接続のためのクラスを使うが、ここではTimeオブジェクトとそれのメソッドで代用
    "#{name}: #{@today.send name} "
  end
end

today = TodayDatetimer.new
# p today.class.instance_methods(false) #　ここには既に「:month, :year, :day」は存在する。まあ当たり前
p today.year
p today.month
p today.day
