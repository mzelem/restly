module Restly::Associations

  ATTR_MATCHER = /(?<attr>\w+)(?<setter>=)?$/

  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :BelongsTo
  autoload :HasMany
  autoload :HasManyThrough
  autoload :HasOne
  autoload :HasOneThrough
  autoload :ClassMethods
  autoload :Handler
  autoload :Definition

  included do

    include Restly::ConcernedInheritance
    include Restly::NestedAttributes

    class_attribute :resource_associations, instance_reader: false, instance_writer: false

    self.resource_associations = HashWithIndifferentAccess.new

    before_save :resource_association_handler_callbacks

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

  def resource_association_handler_callbacks
    (@association_handlers ||= {}).each do |name, handler|
      handler.run_callbacks
    end
  end

  def method_missing(m, *args, &block)
    association_missing(m, *args)
  rescue Restly::Error::InvalidAssociation
    super
  end

end