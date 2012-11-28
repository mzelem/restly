module Restly::Associations::Base::Loaders

  def load(parent, options)

    # Merge Options
    options.reverse_merge!(self.options)

    # Authorize and Set Path
    association = authorize(options[:authorize]).with_path(parent, options[:path])

    # Load Collection or Instance
    collection? ? association.send(:load_collection, parent) : association.send(:load_instance, parent)
  end

  private

  def load_collection(*args)
    raise Restly::Error::NotImplemented, ":#{__method__} not Implemented on this association"
  end

  def load_instance(*args)
    raise Restly::Error::NotImplemented, ":#{__method__} not Implemented on this association"
  end

end