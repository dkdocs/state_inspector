require_relative 'observers/null_observer'

module StateInspector
  # OBSERVABLE PATTERN
  # HASH-LIKE KEY OF OJECT TO OBSERVER/LOGGER INSTANCE
  module Reporter
    class << self
      def [](key)
        reporters[key]
      end

      def []=(key, value)
        reporters[key] = value
      end

      def default observer=nil
        @default = observer if observer
        reporters.default = @default 
        @default
      end

      private
      def reporters
        @reporters ||= Hash.new.tap {|h|
          h.default = @default || Observers::NullObserver
        }
      end
    end
  end
end
