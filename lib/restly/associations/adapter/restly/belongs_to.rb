class Restly::Associations::Adapter::Restly::BelongsTo < Restly::Associations::Adapter::Restly::Handler

  def set(instance)
    store_set(instance)
    proxy!
  end

  def get
    store_get || store_set(associated_class.find owner.send foreign_key)
    proxy!
  end

  def stub
    return nil unless owner.is_a? Restly::Base
    store_set association_class.new owner.parsed_response[association_name] if owner.parsed_response[association_name].present?
  end

end