module Restly::Associations::Adapter::Restly
  include Restly::Associations::Adapter

  define_association_method :belongs_to
  define_association_method :belongs_to_resource, "Adapter::Restly::BelongsTo"
  define_association_method :has_one
  define_association_method :has_one_resource, "Adapter::Restly::HasOne"
  define_association_method :has_many
  define_association_method :has_many_resources, "Adapter::Restly::HasMany"

  class Handler < ::Restly::Associations::Handler
    def resource_path
      association.collection? ? associated_class.resource_name.pluralize : associated_class.resource_name
    end

    def authorize(authorization = nil)
      within_duplicate do
        @association_class = association_class.authorize(authorization)
      end
    end

    def owner_path
      @owner_path ||= owner.is_a?(Restly::Base) ? owner.path : nil
    end

    def proxy!
      if association.collection?
        ::Restly::Associations::Proxy::Collection(self)
      elsif association.instace?
        ::Restly::Associations::Proxy::Instance(self)
      end
    end

    def with_path
      return self unless parent.respond_to? :path
      within_duplicate do
        @association_class = association_class.with_path(resource_path, prepend: owner.path)
      end
    end

  end

end