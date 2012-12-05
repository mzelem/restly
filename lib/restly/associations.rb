module Restly::Associations
  extend ActiveSupport::Autoload
  include Restly::ConcernedInheritance
  include Restly::NestedAttributes

  autoload :Adapter
  autoload :ClassMethods
  autoload :Definition
  autoload :Handler

  def self.included(base)
    load_adapter(base)

    base.class_attribute :resource_associations, instance_reader: false, instance_writer: false

    self.resource_associations = HashWithIndifferentAccess.new

    before_save :resource_association_handler_before_save_callbacks
    after_save :resource_association_handler_after_save_callbacks

    base.inherited do
      self.resource_associations = resource_associations.dup
    end

  end

  def self.load_adapter(base)
    puts "trying to load adapter!"
  end

  def resource_name
    self.class.resource_name
  end

  private

  def association_handlers
    @association_handlers ||= HashWithIndifferentAccess.new
  end

  def association_handler(name)
    association_handlers[name] ||= self.class.reflect_on_resource_association(name).handler(self)
  end

  def resource_association_handler_after_save_callbacks
    (@association_handlers ||= {}).values.each do |handler|
      handler.run_callbacks(:after_save)
    end
  end

  def resource_association_handler_before_save_callbacks
    (@association_handlers ||= {}).values.each do |handler|
      handler.run_callbacks(:before_save)
    end
  end

end