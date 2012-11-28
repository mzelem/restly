class Restly::LocalAssociations::Handler
  extend ActiveSupport::Autoload
  autoload :BelongsTo
  autoload :HasOne
  autoload :HasMany

  include Restly::Associations::Handler::Basics

  before_save do
    Array.wrap(object_storage).each(&:save) if association.options[:autosave]
  end

end