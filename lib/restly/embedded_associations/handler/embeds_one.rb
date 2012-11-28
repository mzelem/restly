class Restly::EmbeddedAssociations::Handler::EmbedsOne < Restly::EmbeddedAssociations::Handler

  def get
    object_storage
  end

  def set(obj)
    raise unless obj.is_a?(association_class) || obj.respond_to?(inverse_of)
    @object_storage = obj
    get
  end

end