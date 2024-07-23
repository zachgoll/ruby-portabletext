module PortableText
  module Serializer
    class Base
      def call(data)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end