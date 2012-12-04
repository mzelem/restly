module Restly::Associations
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :Adapter
  autoload :ClassMethods
  autoload :Definition
  autoload :Handler

  included do

    include Restly::ConcernedInheritance
    include Restly::NestedAttributes

    class_attribute :resource_associations, instance_reader: false, instance_writer: false

    self.resource_associations = HashWithIndifferentAccess.new

    before_save :resource_association_handler_before_save_callbacks
    after_save :resource_association_handler_after_save_callbacks

    inherited do
      self.resource_associations = resource_associations.dup
    end

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
      handler.run_after_save_callbacks
    end
  end

  def resource_association_handler_before_save_callbacks
    (@association_handlers ||= {}).values.each do |handler|
      handler.run_before_save_callbacks
    end
  end

end