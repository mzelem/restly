module Restly::Errors

  DEFAULT = %w{
    RecordNotFound
    InvalidClient
    InvalidObject
    InvalidConnection
    ConnectionError
    MissingId
    InvalidSpec
    InvalidField
    InvalidAssociation
    InvalidAttribute
    InvalidNestedAttribute
    Association
  }

  def define_error(name, inherits_from = StandardError)
    const_set name.to_sym, Class.new(inherits_from)
  end

  def self.extended(klass)
    klass.const_set :Error, Module.new
    DEFAULT.each do |error|
      klass::Error.const_set error.to_sym, Class.new(StandardError)
    end
  end

end