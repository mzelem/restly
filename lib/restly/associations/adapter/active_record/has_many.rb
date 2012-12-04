class Restly::Associations::Adapter::ActiveRecord::HasMany < Restly::Associations::Handler

  after_save :save_collection_and_update_foreign_keys

  def set(collection)
    store_set(collection)
  end

  def get
    store_get || store_set(associated_class.where foreign_key => owner.id)
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