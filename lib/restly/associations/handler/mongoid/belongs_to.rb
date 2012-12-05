class Restly::Associations::Adapter::Mongoid::BelongsTo < Restly::Associations::Handler

  def set(instance)
    store_set(instance)
  end

  def get
    store_get || store_set(associated_class.find owner.send foreign_key)
  end

end