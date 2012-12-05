class Restly::Associations::Adapter::Restly::HasOne < Restly::Associations::Adapter::Restly::Handler

  after_save :save_instance_and_update_foreign_key

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

  def save_instance_and_update_foreign_key
    ensure_one_association
    if store.present?
      store.attributes = { foreign_key => owner.id }
      store.save
    end
  end

end