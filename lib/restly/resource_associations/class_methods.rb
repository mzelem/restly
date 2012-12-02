module Restly::Associations::ClassMethods

  def resource_name
    name.gsub(/.*::/,'').underscore
  end

  def reflect_on_resource_association(association_name)
    reflect_on_all_resource_associations[association_name]
  end

  def reflect_on_all_resource_associations
    resource_associations
  end

  private

  # Belongs to
  def belongs_to_resource(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::Associations::Definition.new(self, name, :belongs_to, options)
  end

  # Has One
  def has_one_resource(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::Associations::Definition.new(self, name, :has_one, options)
  end

  # Has One
  def has_many_resources(name, options = {})
    exclude_field(name) if ancestors.include?(Restly::Base)
    self.resource_associations[name] = Restly::Associations::Definition.new(self, name, :has_many, options)
  end

end