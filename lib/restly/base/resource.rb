module Restly::Base::Resource
  extend ActiveSupport::Autoload
  autoload :Finders

  include Restly::Base::GenericMethods
  include Finders

  # OPTIONS FOR /:path
  # Fetches the spec of a remote resource
  def spec(path=self.path)
    begin
      parsed_response = authorize(client_token).connection.request(:options, path, params: params).parsed
      (parsed_response || {}).with_indifferent_access
    rescue OAuth2::Error
      raise Restly::Error::InvalidSpec, "Unable to load the specification for #{self.class}"
    end
  end

end