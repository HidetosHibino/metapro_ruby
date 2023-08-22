require 'test/unit'

class Person; end

class TestCheckedAttribute < Test::Unit::TestCase
  def setup
    add_checked_attribute(Person, :age)
    @bob = Person.new
  end

  def test_accept_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_nil_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = nil
    end
  end

  def test_refuses_false_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = false
    end
  end
end

def add_checked_attribute(klass, attribute)
  klass.class_eval do
    define_method "#{attribute}=" do |value|
      raise 'Invalid attribute' unless value
      # p self
      # @attribute = value　ここでは self = main?
      # そもそも @attribute が通らない気がする。
      instance_variable_set("@#{attribute}", value)
    end

    define_method attribute do # ここ注意
      instance_variable_get "@#{attribute}"
    end
  end
end

add_checked_attribute(String, 'test_attr')

# インスタンス変数の操作には、 Object#instance_variable_set と Object#instance_variable_get を使う。