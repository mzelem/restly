module Restly::Auth::OAuth2
  extend Restly::ThreadLocal
  thread_local_accessor :current_token

  def self.included(base)
    base.extend ClassMethods
    @enabled = true
  end

  def self.enabled?
    !!@enabled
  end

  module ClassMethods

    def connection
      connection = build_connection
      connection.request :oauth2, Restly::Auth::OAuth2.current_token
      connection
    end

  end

end