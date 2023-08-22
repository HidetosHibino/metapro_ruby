# class Loan
#   def initialize(book)
#     @book = book
#     @time = Time.now
#   end

#   def to_s
#     "#{book.upcase} loaned on #{@time}"
#   end
# end

# @time はシステム時間を取るので、正確な値が取りづらく、テストしにくい。
# 以下のように改修する。

class Loan
  def initialize(book)
    @book = book
    @time = Loan.time_class.now
  end

  def self.time_class
    @time_class ||= Time # self. なので、 selfの結果(セルフオブジェクト)はLoan。 なので@time_class は Loadのクラスインスタンスになる
  end

  def to_s
    "#{@book.upcase} loaned on #{@time}"
  end
end

# Loan.time_classは何らかのクラスを返す。
# Loan#initializeがそのクラスを使って、現在の時刻を取得している。
# このクラスは、@time_classという名前のクラスインスタンス変数に保存されている。

class FakeTime
  def self.now
    'Mon Apr 06 12:15:50'
  end
end

require 'test/unit'

class TestLoan < Test::Unit::TestCase
  def test_conversion_to_string
    Loan.instance_eval { @time_class = FakeTime } # @time_classは Loan”オブジェクト” (クラス：class) のメソッド
    loan = Loan.new('war and peace')
    assert_equal 'WAR AND PEACE loaned on Mon Apr 06 12:15:50', loan.to_s
  end
end
