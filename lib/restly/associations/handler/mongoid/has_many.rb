class Restly::Associations::Adapter::Mongoid::HasMany < Restly::Associations::Handler

  def set(collection)
    store_set(collection)
  end

  def get
    store_get || store_set(associated_class.where foreign_key => owner.id)
  end

end