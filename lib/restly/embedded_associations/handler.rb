class Restly::EmbeddedAssociations::Handler
  extend ActiveSupport::Autoload
  autoload :BelongsTo
  autoload :HasOne
  autoload :HasMany

  include Restly::Associations::Handler::Basics

  def initialize(association, instance)
    super
    @object_storage.parent = _instance_ if @object_storage.method_defined? :parent
  end

end