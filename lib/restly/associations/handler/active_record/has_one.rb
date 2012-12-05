class Restly::Associations::Adapter::ActiveRecord::HasOne < Restly::Associations::Handler

  after_save :save_instance_and_update_foreign_key

  def set(instance)
    store_set(instance)
  end

  def get
    store_get || store_set(associated_class.where(owner.send foreign_key).first)
  end

  def ensure_one_association
    associated_class.where(owner.send foreign_key).update_all(foreign_key => nil)
  end

  def save_instance_and_update_foreign_key
    ensure_one_association
    if store.present?
      store.attributes = { foreign_key => owner.id }
      store.save
    end
  end

end