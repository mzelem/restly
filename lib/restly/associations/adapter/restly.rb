module Restly::Associations::Adapter::Restly
  extend Restly::Associations::Adapter

  class Handler < Restly::Associations::Handler
    def path
      association.collection? ? associated_class.resource_name.pluralize : associated_class.resource_name
    end

    before_save do
      Array.wrap(association_store).each(&:save) if association.options[:autosave]
    end

    def authorize(authorization = nil)
      within_duplicate do
        @association_class = association_class.with_path(association_resource_name, prepend: parent.path)
      end
    end

    def with_path
      return self unless parent.respond_to? :path
      within_duplicate do
        @association_class = association_class.with_path(path)
      end
    end

    def owner_path
      @owner_path ||= owner.is_a?(Restly::Base) ? owner.path : nil
    end

    def proxy!
      if association.collection?
        Restly::Associations::Proxy::Collection(self)
      elsif association.instace?
        Restly::Associations::Proxy::Instance(self)
      end
    end

  end

end