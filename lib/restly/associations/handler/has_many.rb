class Restly::Associations::Handler::HasMany < Restly::Associations::Handler

  after_save do
    @object_storage.each do |instance|
      instance.attributes = { foreign_key => parent.id }
    end
  end

  def get
    @object_storage = if association[:through]
                        parent.send(association[:through]).map(&name.singularize.to_sym)
                      else
                        with_path.all
                      end unless @object_storage.present?
    Restly::Proxies::Associations::Collection.new @object_storage, self
  end

  def set(obj)
    raise unless obj.is_a?(association_class) || obj.respond_to?(inverse_of)
    @object_storage = obj
    get
  end

  private

  def stub
    return nil unless (collection = parent.parsed_response[name.to_s])
    collection.map do |attributes|
      attributes.slice!(*association_class.fields)
      association_class.new(attributes, loaded: false)
    end
  end

end