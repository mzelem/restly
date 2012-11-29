class Restly::Associations::Handler::BelongsTo < Restly::Associations::Handler

  before_save :set_foreign_key

  def get
    @object_storage = association_class.find(foreign_key) unless @object_storage.present?
    Restly::Proxies::Associations::Instance.new @object_storage, self
  end

  def set(obj)
    raise unless obj.is_a?(association_class) || obj.respond_to?(inverse_of)
    @object_storage = obj
    set_foreign_key
    get
  end

  private

  def stub
    return nil unless (attributes = parent.parsed_response[name.to_s])
    attributes.slice!(*association_class.fields)
    association_class.new(attributes, loaded: false)
  end

  def set_foreign_key
    parent.attributes = { foreign_key => @object_storage.id } unless @object_storage.new_record?
  end

  def with_path(path)
    within_duplicate do
      @association_class = association_class.with_path(path)
    end
  end

end