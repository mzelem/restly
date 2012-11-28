module Restly::Associations::Handler::Basics
  extend ActiveSupport::Concern

  included do
    attr_reader :association, :object_storage
    delegate :name, :foreign_key, to: :association
    class_attribute :callbacks, instance_writer: false
    self.after_save_callbacks = []
    self.before_save_callbacks = []
  end

  def initialize(association, instance)
    @_instance_ = instance
    @association = association
    @association_class = instance.send "#{association.name}_type" if association.options[:polymorphic]
    @object_storage ||= stub if respond_to? :stub
  end

  def set(value)
    raise Restly::Error::NotImplemented
  end

  def get
    raise Restly::Error::NotImplemented
  end

  def stub
    raise Restly::Error::NotImplemented
  end

  def run_before_save_callbacks
    before_save_callbacks.each do |callback|
      case callback
        when Symbol
          send(callback)
        when Proc
          instance_eval(&callback)
        else
          raise InvalidCallback, "Callback must be a symbol or proc."
      end
    end
  end

  def run_after_save_callbacks
    after_save_callbacks.each do |callback|
      case callback
        when Symbol
          send(callback)
        when Proc
          instance_eval(&callback)
        else
          raise InvalidCallback, "Callback must be a symbol or proc."
      end
    end
  end

  def association_class
    @association_class || association.association_class
  end

  private

  def _instance_
    @_instance_
  end

  def within_duplicate(&block)
    dup.instance_eval(&block)
  end

  module ClassMethods

    def after_save(method=nil, &block)
      self.after_save_callbacks << method || block
    end

    def before_save(method=nil, &block)
      self.before_save_callbacks << method || block
    end

  end

end