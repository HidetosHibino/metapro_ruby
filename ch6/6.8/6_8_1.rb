# クイズ：アトリビュートのチェック
# CheckedAttributesはインクルーダーのクラスメソッドとして、attr_cheched を定義する。

module CheckedAttributes
  def self.included(base)
    base.extend ClassMethod
  end

  module ClassMethod
    # attr_checked はクラスメソッドとして定義される。 (Base#attr_checked)
    # その中で、define_method される。
    def attr_checked(attribute, &validation)
      define_method "#{attribute}=" do |value|
        raise 'Invalid attribute' unless validation.call(value)
        instance_variable_set("@#{attribute}", value)
      end

      define_method attribute do
        instance_variable_get "@#{attribute}"
      end
    end
  end
end

class Person
  include CheckedAttributes # 追加

  attr_checked :age do |v|
    v > 18
  end
end

require 'test/unit'

class TestCheckedAttribute < Test::Unit::TestCase
  def setup
    @bob = Person.new
  end

  def test_accept_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_invalid_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = 17
    end
  end
end