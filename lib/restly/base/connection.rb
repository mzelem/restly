module Restly::Base::Connection
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    class_attribute :connection_builder, instance_writer: false

    define_connection { |builder| builder.adapter Faraday.default_adapter }
  end

  module ClassMethods

    def define_connection(&block)
      raise ArgumentError, 'must provide a block for configuration' unless block_given?
      raise ArgumentError, 'block expects a builder argument' unless block.arity == 1
      self.connection_builder = block
    end

    def connection
      @connection ||= build_connection
    end

    private

    def build_connection
      connection = Faraday.new(url: self.site, &self.connection_builder)
      connection.response :xml, content_type: /\bxml$/
      connection.response :json, content_type: /\bjson$/
      connection
    end

  end

  def connection
    @connection ||= self.class.connection.dup
  end

end