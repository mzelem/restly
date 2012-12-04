class Restly::Associations::Adapter::Restly::HasMany < Restly::Associations::Adapter::Restly::Handler

  after_save :save_collection_and_update_foreign_keys

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

  def save_collection_and_update_foreign_keys
    if store.present?
      store.each do |instance|
        instance.attributes = { foreign_key => owner.id }
        instance.save
      end
    end
  end

end