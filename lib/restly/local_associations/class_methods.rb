module Restly::LocalAssociations::ClassMethods

  private

  # Belongs to
  def belongs_to_local(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::LocalAssociations::Definition.new(self, name, :belongs_to, options)
  end

  # Has One
  def has_one_local(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::LocalAssociations::Definition.new(self, name, :has_one, options)
  end

  # Has One
  def has_many_local(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::LocalAssociations::Definition.new(self, name, :has_many, options)
  end

end