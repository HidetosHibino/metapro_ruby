require 'monetize'
# gem install monetize

I18n.config.available_locales = [:ja, :en]
I18n.config.default_locale = :en

# Monetizeクラスと提供されるメソッド
bargain_price = Monetize.from_numeric(99, 'USD')
p bargain_price.format

# Numericインスタンス(100)に対してto_moneyメソッドが使えるようになっていることに注目。
standard_price = 100.to_money('USD')
p standard_price.format


# monetize gemで Numericを再オープンして、to_moneyメソッドを付与している
# ゆえに　Numericインスタンス(100)に対してto_moneyメソッドが使えるようになっている

# https://github.com/RubyMoney/monetize/blob/e2e2f1f2dbc8e599797f7582dc389bdde9ac6999/lib/monetize/core_extensions/numeric.rb#L4
# lib/monetize/core_extensions/numeric.rb
# encoding: utf-8
class Numeric
  def to_money(currency = nil)
    Monetize.from_numeric(self, currency || Money.default_currency)
  end
end
