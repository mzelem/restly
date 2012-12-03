class Restly::Associations::Handler
  extend Restly::Errors
  define_error :InvalidCallback

  attr_reader :association, :owner
    delegate :name, :foreign_key, to: :association
    class_attribute :after_save_callbacks, :before_save_callbacks, instance_writer: false
    self.after_save_callbacks = []
    self.before_save_callbacks = []

  def self.after_save(method=nil, &block)
    self.after_save_callbacks << method || block
  end

  def self.before_save(method=nil, &block)
    self.before_save_callbacks << method || block
  end

  def initialize(association, owner)
    @owner = owner
    @association = association
    @association_class = instance.send "#{association.name}_type" if association.options[:polymorphic]
    @object_storage ||= stub if respond_to? :stub
  end

  def association_class
    @association_class || association.association_class
  end

  def get
    raise NotImplemented
  end

  def set(value)
    raise NotImplemented
  end

  def stub
    raise NotImplemented
  end

  def run_after_save_callbacks
    after_save_callbacks.each do |callback|
      case callback
        when Symbol
          send(callback)
        when Proc
          instance_eval(&callback)
        else
          raise Error::InvalidCallback, "Callback must be a symbol or proc."
      end
    end
  end

  def run_before_save_callbacks
    before_save_callbacks.each do |callback|
      case callback
        when Symbol
          send(callback)
        when Proc
          instance_eval(&callback)
        else
          raise Error::InvalidCallback, "Callback must be a symbol or proc."
      end
    end
  end

  def within_duplicate(&block)
    dup.instance_eval(&block)
  end

end