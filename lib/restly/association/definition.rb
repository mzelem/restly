class Restly::Associations::Definition
  extend ActiveSupport::Autoload

  Errors = Restly::Associations::Errors

  All = []

  class_attribute :method_definitions, instance_writer: false
  self.method_definitions = []

  class << self

    def define_owner_method(name, options={}, &block)
      options.assert_valid_keys(:if, :unless)
      raise Restly::Error::InvalidObject, "Must provide a block." unless block_given?
      self.method_definitions << { name: name, block: block, options: options }
    end

  end

  define_owner_method ->{ "#{name}" } do
    association_handler(name).get
  end

  define_owner_method ->{ "#{name}=" } do |value|
    association_handler(name).set value
  end

  define_owner_method ->{ "build_#{name}" }, if: :instance? do
    association_handler(name).set association_class.new
  end

  attr_reader :name, :options, :handler_type, :owner_class

  def initialize(owner_class, name, handler_type, options={})
    @handler_type = handler_type
    options.assert_valid_keys *valid_options
    options[:namespace]  ||= owner_class.name.gsub(/(::)?\w+$/, '')
    options[:class_name] ||= name.to_s.classify
    owner_class = owner_class
    @inverse_of = options[:as] || options.delete(:inverse_of)
    @name = name
    @foreign_key = options.delete(:foreign_key)
    @options = options
    write_methods_to_owner_class
    All << self
  end

  def inverse_of
    @inverse_of || inverse_definition.name
  end

  def inverse_definition
    raise NoInverseForPolymorphicAssociation, "This association has no inverse definition because it is Polymorphic." if options[:polymorphic]
    All.find { |definition| definition.associated_class == owner_class }
  end

  def associated_class
    [options[:namespace], options[:class_name]].compact.join('::').constantize
  end

  def foreign_key
    @foreign_key || handler_type == :belongs_to ? :"#{name}_id" : inverse_definition.foreign_key
  end

  def association_resource_name
    collection? ? associated_class.resource_name.pluralize : associated_class.resource_name
  end

  def collection?
    handler_type.in? [:has_many]
  end

  def instance?
    !collection?
  end

  private

  def valid_options
    [
      :class_name,
      :class,
      :inverse_of,
      :namespace,
      :foreign_key,
      (:as if handler_type.to_s =~ /^has/ ),
      (:through if handler_type.to_s =~ /^has/ ),
      (:polymorphic if handler_type == :belongs_to)
    ].compact
  end

  def handler(owner_instance)
    definition_namespace = self.class.name.name.gsub(/(::)?\w+$/, '')
    handler = handler_type.classify
    [definition_namespace, handler].compact.join('::').constantize.new(self, owner_instance)
  end

  def write_methods_to_owner_class

    method_definitions.each do |options|
      name = options.delete(:name)
      block = options.delete(:block)
      options = options.delete(:options)

      return if ( options[:if] && !instance_eval(&options[:if]) ) ||
                ( options[:unless] && instance_eval(&options[:unless]) )

      instance_eval(&name) if name.is_a?(Proc)
      unless owner_class.method_defined?(name)
        owner_class.send :define_method, name.to_sym, &block
      end
    end

  end

end