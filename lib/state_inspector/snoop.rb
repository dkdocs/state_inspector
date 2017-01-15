require_relative 'state_inspector'
require_relative 'reporter'

module StateInspector
  module Snoop
    def Snoop.extended(base)
      base.include ClassMethods
    end

    def attr_writer attr_name
      define_method("#{attr_name}=") do |value|
        tell_si __method__.to_s.chomp,
          instance_variable_get("@#{attr_name.to_s}"),
          value 

        instance_variable_set("@#{attr_name.to_s}", value)
      end
      nil
    end

    def attr_accessor attr_name
      define_method("#{attr_name}") do
        instance_variable_get("@#{attr_name.to_s}")
      end

      self.attr_writer(attr_name)
    end

    module ClassMethods
      def state_inspector
        @@state_inspector ||= StateInspector.new
      end

      def tell_si what, old, new
        state_inspector.report( self, "@#{what.to_s}", old, new ) if informant?
      end

      def toggle_informant
        @informant = !@informant
      end

      def informant?
        @informant || self.class.instance_variable_get(:@informant)
      end
    end
  end
end