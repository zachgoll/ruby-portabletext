module PortableText
  module Serializer
    class Base
      def call(inner_html, data = nil)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end