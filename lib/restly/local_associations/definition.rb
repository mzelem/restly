class Restly::LocalAssociations::Definition < Restly::Associations::Definition

  def valid_options
    [
      :class_name,
      :class,
      :inverse_of,
      :namespace,
      :foreign_key,
      (:as if handler_type.to_s =~ /^has/ ),
      (:through if handler_type.to_s =~ /^has/ ),
      (:polymorphic if handler_type == :belongs_to)
    ].compact
  end

  def define

end