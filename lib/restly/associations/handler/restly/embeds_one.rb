class Restly::Associations::Adapter::Restly::EmbedsOne < Restly::Associations::Adapter::Restly::Handler

  def get
    owner_get || owner_set(association_class.new owner.parsed_response[association_name])
    proxy!
  end

  def set(instance)
    owner_set instance
    proxy!
  end

end