module SentientModel
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    def current
      Thread.current[model_name.param_key]
    end

    def current=(object)
      unless object.instance_of?(self) || object.nil?
        raise ArgumentError, "Expected an instance of class '#{self.class}', got #{object.inspect}"
      end
      Thread.current[model_name.param_key] = object
    end

    def do_as(object, &block)
      old_object = current

      begin
        self.current = object
        response = block.call unless block.nil?
      ensure
        self.current = old_object
      end

      response
    end
  end

  module InstanceMethods
    def make_current
      Thread.current[self.class.model_name.param_key] = id
    end

    def current?
      !Thread.current[model_name.param_key].nil? && id == Thread.current[model_name.param_key].id
    end
  end
end
