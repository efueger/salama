module Typed
  module Tree
    class Assignment < Statement
      attr_accessor :name , :value
      def initialize(n = nil , v = nil )
        @name , @value = n , v
      end
    end
  end
end
