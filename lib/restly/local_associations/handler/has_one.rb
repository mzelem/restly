class Restly::LocalAssociations::Handler::HasOne < Restly::LocalAssociations::Handler

  after_save do
    association_class.update_all({ foreign_key => nil })
    @object_storage.update_attributes({ foreign_key => parent.id })
  end

  def get
    @object_storage ||= association_class.where({ foreign_key => parent_id }).first
    @object_storage
  end

  def set(obj)
    raise unless obj.is_a?(association_class) || obj.respond_to?(inverse_of)
    @object_storage = obj
    get
  end

end