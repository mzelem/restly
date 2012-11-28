module Restly::EmbeddedAssociations::ClassMethods

  private

  # Belongs to
  def embedded_in(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::LocalAssociations::Definition.new(self, name, :embedded_in, options)
  end

  # Has One
  def embeds_one(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::LocalAssociations::Definition.new(self, name, :embeds_one, options)
  end

  # Has One
  def embeds_many(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::LocalAssociations::Definition.new(self, name, :embeds_many, options)
  end

end