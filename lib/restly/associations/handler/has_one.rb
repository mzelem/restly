class Restly::Associations::Handler::HasOne < Restly::Associations::Handler

  after_save do
    @object_storage.update_attributes({ foreign_key => parent.id })
  end

  def get
    @object_storage = if association[:through]
                        parent.send(association[:through]).send(name.singularize)
                      else
                        with_path.first
                      end unless @object_storage.present?
    Restly::Proxies::Associations::Instance.new @object_storage, self
  end

  def set(obj)
    raise unless obj.is_a?(association_class) || obj.respond_to?(inverse_of)
    @object_storage = obj
    get
  end

  private

  def stub
    return nil unless (attributes = parent.parsed_response[name.to_s])
    attributes.slice!(*association_class.fields)
    association_class.new(attributes)
  end

end