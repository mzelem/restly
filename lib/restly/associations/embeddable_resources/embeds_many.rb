class Restly::Associations::EmbeddableResources::EmbedsMany < Restly::Associations::Base

  def collection?
    true
  end

  def embedded?
    true
  end

end