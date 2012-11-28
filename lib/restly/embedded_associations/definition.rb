class Restly::EmbeddedAssociations::Definition < Restly::Associations::Definition

  def valid_options
    [
      :class_name,
      :class,
      :inverse_of,
      :namespace
    ].compact
  end

  undef_method :foreign_key

end