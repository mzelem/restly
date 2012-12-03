class Restly::Associations::Definition
  extend ActiveSupport::Autoload
  extend Restly::Errors

  define_error :NoInverseForPolymorphicAssociation

  ALL = [] # Holds all possible Associations

  # Set a collection to hold all method procs to be defined on the owner.
  class_attribute :method_definitions, instance_writer: false
  self.method_definitions = []

  class << self

    private

    # Class method to be defin owner methods
    def define_owner_method(name, options={}, &block)
      raise Error::InvalidObject, "Must provide a block." unless block_given?
      self.method_definitions << { name: name, block: block, options: options }
    end

  end

  # Set the association getter on the owner
  define_owner_method ->{ "#{name}" } do
    association_handler(name).get
  end

  # Set the association setter on the owner
  define_owner_method ->{ "#{name}=" } do |value|
    association_handler(name).set value
  end

  # Set the association builder for instances on the owner
  define_owner_method ->{ "build_#{name}" }, if: :instance? do
    association_handler(name).set association_class.new
  end

  # Attr Readers
  attr_reader :name,          # Name of the association
              :options,       # Association Options
              :owner_class,    # Owner class where the association is defined
              :handler_type  # The Class that Handles the Association


  def initialize(owner_class, name, handler_class, options={})
    # Set instance vars
    @name = name
    @handler_type = handler_class
    @owner_class = owner_class
    @options = options.freeze

    write_methods_to_owner_class
    ALL << self
  end

  # The class for the associated objects
  def associated_class
    @associated_class ||= [
      options[:namespace],
      (options[:class_name] || name.to_s.classify)
    ].compact.join('::').constantize
  end

  def collection?
    handler_type.in? [:has_many]
  end

  # The foreign key in which the parent id is stored
  def foreign_key
    options[:foreign_key] || handler_type == :belongs_to ? :"#{name}_id" : inverse_definition.foreign_key
  end

  def handler(owner_instance)
    handler_class.new(self, owner_instance)
  end

  def instance?
    !collection?
  end

  def inverse_of
    options[:as] || options[:inverse_of] || inverse_definition.name
  end

  private

  def handler_class
    adapter = Adapter.determine(associated_class).classify
    handler = handler_type.classify
    adapter.constantize.const_get handler
  end

  def inverse_definition
    raise Error::NoInverseForPolymorphicAssociation, "This association has no inverse definition because it is Polymorphic." if options[:polymorphic]
    ALL.find { |definition| definition.associated_class == owner_class }
  end

  # The namespace in which the associated class exists
  def namespace
    @namspace ||= options[:namespace] || owner_class.name.gsub(/(::)?\w+$/, '')
  end

  def write_methods_to_owner_class

    method_definitions.each do |options|
      name = options.delete(:name)
      block = options.delete(:block)
      options = options.delete(:options)

      options.assert_valid_keys(:if, :unless)

      return if ( options[:if] && !instance_eval(&options[:if]) ) ||
                ( options[:unless] && instance_eval(&options[:unless]) )

      instance_eval(&name) if name.is_a?(Proc)
      unless owner_class.method_defined?(name)
        owner_class.send :define_method, name.to_sym, &block
      end
    end

  end

end