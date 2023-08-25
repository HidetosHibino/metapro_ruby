# activerecord-4.1.0/lib/active_record/attribute_methods/read.rb

module ActiveRecord
  module AttributeMethods
    module Read

      extend ActiveSupport::Concern
      module ClassMethods

        if Module.methods_transplantable?
          def define_method_attribute(name)
            method = ReaderMethodCache[name]
            generated_attribute_methods.module_eval { define_method name, method }
          end
        else
          def define_method_attribute(name)
            safe_name = name.unpack('h*').first
            temp_method = "__temp__#{safe_name}"

            ActiveRecord::AttributeMethods::AttrNames.set_name_cache safe_name, name

            generated_attribute_methods.module_eval <<-STR, __FILE__, __LINE__ + 1
              def #{temp_method}
                name = ::ActiveRecord::AttributeMethods::AttrNames::ATTR_#{safe_name}
                read_attribute(name) { |n| missing_attribute(n, caller) }
              end
            STR

            generated_attribute_methods.module_eval do
              alias_method name, temp_method
              undef_method temp_method
            end
          end
        end

      end
    end
  end
end
