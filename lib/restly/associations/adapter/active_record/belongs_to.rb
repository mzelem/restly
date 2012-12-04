class Restly::Associations::Adapter::ActiveRecord::BelongsTo < Restly::Associations::Handler

  before_save :save_instance_and_update_foreign_key

  def get
    store_get || store_set(associated_class.find owner.send foreign_key)
  end

  def set(instance)
    store_set(instance)
  end

  def save_instance_and_update_foreign_key
    @store.save if @store.respond_to? :save if @store.respond_to? :attributes
    owner.attributes = { foreign_key => @store.id }
  end

end