module Restly::Associations::Adapter::Restly
  extend Restly::Associations::Adapter
  extend ActiveSupport::Autoload

  autoload :BelongsTo
  autoload :EmbeddedIn
  autoload :EmbedsMany
  autoload :EmbedsOne
  autoload :HasMany
  autoload :HasOne

  def self.included(base)
    define_association_methods base
  end

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

    def parent_path
      @parent_path ||= parent.respond_to?(:path) ? parent.path : nil
    end

  end

end