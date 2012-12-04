class Restly::Associations::Proxy < Restly::Proxies::Base

  attr_reader :handler
  delegate :association_class, :association, to: :handler

  def initialize(handler)
    @handler = handler
    super handler.store
  end

  def parent
    handler.owner
  end

end