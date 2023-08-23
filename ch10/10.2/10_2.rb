# ActiveRecord::Concern は includeと extend のトリックをカプセル化して、include の連鎖の問題を解決している。
# この機能を手に入れるには、モジュールで Concern をextend して、自身のClassMethodsモジュールを定義する。

require 'active_support'

module MyConcern
  extend ActiveSupport::Concern

  def an_instance_method; 'インスタンスメソッド'; end

  module ClassMethods
    def an_class_method; 'クラスメソッド'; end
  end
end

class MyClass
  include MyConcern
end

p MyClass.new.an_instance_method
p MyClass.an_class_method
