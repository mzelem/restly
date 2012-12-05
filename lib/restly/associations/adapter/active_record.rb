module Restly::Associations::Adapter::ActiveRecordAdapter
  include Restly::Associations::Adapter

  define_association_method :belongs_to_resource, "Adapter::Restly::BelongsTo"
  define_association_method :has_one_resource, "Adapter::Restly::HasOne"
  define_association_method :has_many_resources, "Adapter::Restly::HasMany"

end