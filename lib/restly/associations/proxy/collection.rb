class Restly::Associations::Proxy::Collection < Restly::Associations::Proxy

  def initialize
    super
    reciever_get.try(:map) do |instance|
      instance.extend Module.new do
        def parent
          handler.owner
        end
      end
    end
  end

  def create(attributes={})
    attributes.merge({ inverse_of => owner }) if association_class.method_defined? inverse_of
    handler.set association_class.create(attributes)
  end

  def new(attributes={})
    attributes.merge({ inverse_of => owner }) if association_class.method_defined? inverse_of
    handler.set association_class.new(attributes)
  end

  alias :build :new

end