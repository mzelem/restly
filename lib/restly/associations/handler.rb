class Restly::Associations::Handler
  extend ActiveSupport::Autoload
  autoload :Callbacks
  include Callbacks

  extend Restly::Errors
  define_error :InvalidCallback
  define_error :WrongTypeOfInstance

  attr_reader :association, :owner, :store
  delegate :name, :foreign_key, to: :association

  private

  def initialize(association, owner)
    @owner = owner
    @association = association
    @associated_class = instance.send "#{association.name}_type" if association.options[:polymorphic]
    stub if respond_to? :stub
  end

  def associated_class
    @associated_class || association.associated_class
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

  def store_set(instance)
    @store = instance
    validate!
  end

  def store_get
    @store
  end

  def validate!
    if Array.wrap(store).find { store.class != associated_class }
      @store = nil
      raise Error::WrongTypeOfInstance, "#{store} must be an instance of #{associated_class}"
    else
      store
    end
  end

  def within_duplicate(&block)
    dup.instance_eval(&block)
  end

end