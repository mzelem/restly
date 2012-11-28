class Restly::Proxies::Associations::Instance < Restly::Proxies::Base

  attr_reader :handler

  def initialize(instance, handler)
    super(instance)
    @handler = handler
  end

end