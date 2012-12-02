class Restly::EmbeddedAssociations::Handler < Restly::Associations::Handler::Base
  extend ActiveSupport::Autoload
  autoload :BelongsTo
  autoload :HasOne
  autoload :HasMany

  def initialize(association, instance)
    super
    @object_storage.parent = _instance_ if @object_storage.method_defined? :parent
  end

end