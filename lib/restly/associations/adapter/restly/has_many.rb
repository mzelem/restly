class Restly::Associations::Adapter::Restly::HasMany < Restly::Associations::Adapter::Restly::Handler

  def set(collection)
    store_set(collection)
    proxy!
  end

  def get
    store_get || store_set(handler.with_path.associated_class owner.send foreign_key)
    proxy!
  end

  def stub
    return nil unless owner.is_a? Restly::Base
    store_set association_class.new owner.parsed_response[association_name] if owner.parsed_response[association_name].present?
  end

end