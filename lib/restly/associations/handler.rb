class Restly::Associations::Handler
  extend ActiveSupport::Autoload
  autoload :BelongsTo
  autoload :HasOne
  autoload :HasMany
  autoload :Basics

  include Basics

  before_save do
    Array.wrap(@object_storage).each(&:save) if association.options[:autosave]
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

  private

  def parent_path
    @parent_path ||= parent.respond_to?(:path) ? parent.path : nil
  end

end