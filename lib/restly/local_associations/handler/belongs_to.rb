class Restly::LocalAssociations::Handler::BelongsTo < Restly::LocalAssociations::Handler

  before_save do
    parent.attributes = { foreign_key => @object_storage.id }
  end

  def initialize(association, parent)
    @association_class = parent.send "#{association.name}_type" if association.options[:polymorphic]
  end

  def get
    @object_storage ||= association_class.find(foreign_key)
    @object_storage
  end

  def set(obj)
    raise unless obj.is_a?(association_class) || obj.respond_to?(inverse_of)
    @object_storage = obj
    get
  end

end