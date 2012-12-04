require 'active_support/dependencies/autoload'

module Restly::Associations::Adapter
  extend ActiveSupport::Autoload

  autoload :ActiveRecord
  autoload :Mongoid
  autoload :Restly

  def self.extended(base)
    Builder.new(base).setup
  end

  def self.determine(klass)
    klass = klass.constantize if klass.is_a? String

    if klass.ancestors.include? Restly::Base
      :restly
    elsif klass.ancestors.include? ActiveRecord::Base
      :active_record
    elsif klass.ancestors.include? Mongoid::Document
      :mongoid
    else
      raise NotImplementedError
    end
  end

  class Builder

    attr_reader :base, :included_in

    def initialize(base)
      @base = base
      @included_in = caller[1].gsub(/\.rb:.*/,'')
      setup
    end

    def setup
      autoload_constants
      define_included
    end

    private

    def handlers
      directory = File.expand_path File.join __FILE__, "..", "adapter", included_in, "*" # "../lib/restly/associations/adapter/#{adapter_name}/*"
      Dir.glob(directory).map do |file|
        /.*\/(?<underscore_name>.*)\.rb/ =~ file
        underscore_name.to_sym
      end
    end

    def autoload_constants
      base.extend(ActiveSupport::Autoload)
      handlers.each do |handler|
        base.autoload handler
      end
    end

    def define_included
      base.define_singleton_method :included do |owner|
        define_methods owner
      end
    end

    def define_methods(owner)
      handlers.each do |handler|
        owner.define_singleton_method name do
          Restly::Associations::Definition.new(self, name, handler, options)
        end
      end
    end

  end

end