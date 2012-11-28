class Restly::LocalAssociations::Handler::HasMany < Restly::LocalAssociations::Handler

  after_save do
    @object_storage.each do |instance|
      instance.update_attributes({ foreign_key => parent.id })
    end
  end

  def get
    @object_storage ||= association_class.where(foreign_key => parent_id)
    @object_storage
  end

  def set(obj)
    raise unless obj.is_a?(association_class) || obj.respond_to?(inverse_of)
    @object_storage = obj
    get
  end

end