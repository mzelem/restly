class Restly::Associations::ClassMethods < Restly::Associations::Definition
  extend Restly::Errors

  def self.extended(base)
    if descendant_of? base, Restly::Base
      base.include Restly::Associations::Adapter::Restly
    elsif descendant_of? base, ActiveRecord::Base
      base.include Restly::Associations::Adapter::ActiveRecord
    elsif descendant_of? base, Mongoid::Document
      base.include Restly::Associations::Adapter::Mongoid
    else
      raise NotImplementedError, "Associations to this type of class are not supported."
    end
  end

  def self.descendant_of?(base, klass)
    base.ancestors.include? klass
  end

end
