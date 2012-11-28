class Restly::Proxies::Associations::Collection < Restly::Proxies::Base

  attr_reader :handler

  def initialize(collection, handler)
    collection.map!{ |instance| Restly::Proxies::Associations::Instance.new(instance, handler) }
    super(collection)
    @handler = handler
  end

  def <<(instance)
    collection = super
    instance.save unless instance.persisted?
    if (joiner = handler.association.options[:through])
      joiner.new("#{handler_name}_id" => parent.id, "#{instance.resource_name}_id" => instance.id)
    elsif parent
      instance.update_attributes("#{parent.resource_name}_id" => parent.id)
    end
    collection
  end

end