# include の連鎖の問題

# インクルードするモジュールが、また別のモジュールをインクルードしているとしよう。
# ActiveRecord::Baseが ActiveRecord::Validations をインクルードして、それがまた ActiveModel::Validations をインクルードしている場合。

# 両方のモジュールが、includeと extend のトリックを使っていたとしたら、何が起きるか？

module SecondLevelModule
  def self.included(base)
    base.extend ClassMethods
  end

  def second_level_instance_method; 'ok' end

  module ClassMethods
    def second_level_class_method; 'ok' end
  end
end

# module FirstLevelModule
#   def self.included(base)
#     base.extend ClassMethods
#   end

#   def first_level_instance_method; 'ok' end

#   module ClassMethods
#     def first_level_class_method; 'ok' end
#   end

#   include SecondLevelModule
# end

# class BaseClass
#   include FirstLevelModule
# end

# p BaseClass.new.first_level_instance_method
# p BaseClass.new.second_level_instance_method

# p BaseClass.first_level_class_method
# p BaseClass.second_level_class_method # undefined method `second_level_class_method' for BaseClass:Class (NoMethodError)

# Ruby が SecondLevelModule.included を呼び出すとき、変数base は BaseClass ではなく、FirstLevelModuleになっている。
# その結果、SecondLevelModule::ClassMethods のメソッドは FirstLevelModuleのクラスメソッドになっている。

# 解決するためには、FirstLevelModulenの中で、 インクルーダーにSecondLevelModule をインクルードさせるようにした。

module FirstLevelModule
  def self.included(base)
    base.extend ClassMethods
    base.send :include, SecondLevelModule
  end

  def first_level_instance_method; 'ok' end

  module ClassMethods
    def first_level_class_method; 'ok' end
  end

  include SecondLevelModule
end

class BaseClass
  include FirstLevelModule
end


p BaseClass.new.first_level_instance_method
p BaseClass.new.second_level_instance_method

p BaseClass.first_level_class_method
p BaseClass.second_level_class_method # undefined method `second_level_class_method' for BaseClass:Class (NoMethodError)
