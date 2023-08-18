# 動的プロキシにする。

class TodayDatetimer
  def initialize
    @today = Time.now
  end

  def method_missing(name)
    # @todayが :name メソッドを持つ場合、そのまま。
    # @todayが :name メソッドを持たない場合、super (BasicObject）の　method_mising　を呼び出す。
    super if !@today.respond_to?(name)
    "#{name}: #{@today.send name} "
  end
end

today = TodayDatetimer.new
# p today.class.instance_methods(false) #　ここには既に「:month, :year, :day」は存在する。まあ当たり前
p today.year
p today.month
p today.day
# p today.not_defined_method

# そのままでは respond_to ではゴーストメソッドに反応しない。
day = TodayDatetimer.new
p day.respond_to? :year # -> false

# respond_to? は respond_to_missing? というメソッドを呼び出している。
# これはメソッドがゴーストメソッドだった時にtrueを返すメソッド
# method_missingをオーバーライドしたときに、respond_to_missing? もオーバーライドする。

class TodayDatetimer
  def respond_to_missing?(method, include_private = false)
    @today.respond_to?(method) || super
  end
end

p day.respond_to? :year # -> true

# 定数版の const_missing も存在する
