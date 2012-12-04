require 'active_support/dependencies/autoload'

module Restly::Associations::Adapter
  extend ActiveSupport::Autoload
  autoload :ActiveRecord
  autoload :Mongoid
  autoload :Restly

  extend ActiveSupport::Concern

  included do
    extend AdapterAutoload
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

  module AdapterAutoload

    def self.extended(base)
      base.extend(ActiveSupport::Autoload)
      directory = File.expand_path File.join __FILE__, "..", "adapter", caller[1].gsub(/\.rb:.*/, ''), "*"
      Dir.glob(directory).map do |file|
        /.*\/(?<underscore_name>.*)\.rb/ =~ file
        base.autoload handler.classify.to_sym
      end
    end

  end

  module ClassMethods

    def define_association_method(symbol, handler=nil)
      handler ||= symbol
      define_singleton_method symbol do |name, options={}|
        Restly::Associations::Definition.new(self, name, handler, options)
      end
    end

  end

end