module Restly::Associations::Adapter
  extend ActiveSupport::Autoload

  autoload :ActiveRecord
  autoload :Mongoid
  autoload :Restly

  def self.determine(klass)
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

  def association_methods
    constants.map(&:to_s).map(&:underscore)
  end

  def define_association_methods(base, association_methods=self.association_methods)
    association_methods.each do |m|
      base.send :define_singleton_method, m do |name, options={}|
        Restly::Associations::Definition.new(self, name, m, options)
      end
    end
  end

end