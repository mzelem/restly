module Restly::Associations::Adapter::ActiveRecord
  extend Restly::Associations::Adapter 
  extend ActiveSupport::Autoload

  autoload :BelongsTo
  autoload :HasMany
  autoload :HasOne

  def self.included(base)
    define_association_methods base
  end

end