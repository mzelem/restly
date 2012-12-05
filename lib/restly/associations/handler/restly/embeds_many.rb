class Restly::Associations::Adapter::Restly::EmbedsMany < Restly::Associations::Adapter::Restly::Handler

  def get
    owner_get || owner_set(owner.parsed_response[association_name].map { |instance| association_class.new(instance) })
    proxy!
  end

  def set(instance)
    owner_set instance
    proxy!
  end

end