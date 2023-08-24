module ActiveRecord
  module Validations

    def self.included(base) # :nodoc:
      base.extend ClassMethods
      base.class_eval do
        alias_method_chain :save, :validation
        alias_method_chain :save!, :validation
      end

      base.send :include, ActiveSupport::Callbacks
      base.define_callbacks *VALIDATIONS
    end

  end
end

