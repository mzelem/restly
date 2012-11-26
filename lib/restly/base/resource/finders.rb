module Restly::Base::Resource::Finders

  Collection = Restly::Collection

  def find(id, *args)
    options = args.extract_options!

    #params[pagination_options[:params][:page]] = options[:page] if pagination
    instance_from_response connection.get(path_with_format(id), params: params)
  end

  def all
    collection_from_response connection.get(path_with_format, params: params)
  end

  def create(attributes = nil, options = {})
    instance = self.new(attributes, options)
    instance.save
  end

  def collection_from_response(response)
    raise Restly::Error::InvalidResponse unless response.is_a? OAuth2::Response
    Collection.new resource, nil, response: response
  end

  def instance_from_response(response)
    raise Restly::Error::RecordNotFound, "Could not find a #{name} at the specified path." unless response.status < 400
    new(nil, response: response, connection: connection)
  end

  alias_method :from_response, :instance_from_response

end