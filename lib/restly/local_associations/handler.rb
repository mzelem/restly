class Restly::LocalAssociations::Handler < Restly::Associations::Handler::Base
  extend ActiveSupport::Autoload
  autoload :BelongsTo
  autoload :HasOne
  autoload :HasMany

  before_save do
    Array.wrap(object_storage).each(&:save) if association.options[:autosave]
  end

end