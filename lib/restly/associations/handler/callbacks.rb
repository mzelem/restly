module Restly::Associations::Callbacks
  extend ActiveSupport::Concern
  
  included do
    class_attribute :callbacks, instance_writer: false
  end

  def run_after_save_callbacks
    run_save_callbacks :after_save
  end

  def run_before_save_callbacks
    run_save_callbacks :before_save
  end

  def run_save_callbacks(type)
    callbacks.select { |item| item[:options][:type] == type }.each do |cb_hash|
      callback = cb_hash[:callback]
      options = cb_hash[:options]

      return if (options[:if] && !instance_eval(&options[:if])) ||
          (options[:unless] && instance_eval(&options[:unless]))

      case callback
      when Symbol
        send(callback)
      when Proc
        instance_eval(&callback)
      else
        raise Error::InvalidCallback, "Callback must be a symbol or proc."
      end
    end
  end
  
  module ClassMethods

    def after_save(*args, &block)
      add_callbacks(*args, type: :after_save, &block)
    end

    def before_save(*args, &block)
      add_callbacks(*args, type: :before_save, &block)
    end

    def add_callbacks(*args, &block)
      options = args.extract_options!
      if args.present? && block_given?
        raise ArgumentError, "Callback cannot accept a block and an argument"
      elsif args.present?
        args.each { |method| add_callback(method) }
      elsif block_given?
        add_callback(nil, options, &block)
      else
        raise ArgumentError, "Callback expects a block or an argument"
      end
    end

    def add_callback(method=nil, options={ }, &block)
      callback = if method && block_given?
                   raise ArgumentError, "Callback cannot accept a block and an argument"
                 elsif method
                   method
                 elsif block_given?
                   block
                 else
                   raise ArgumentError, "Callback expects a block or an argument"
                 end

      self.callbacks << { callback: callback, options: options }
    end
    
  end
  
end