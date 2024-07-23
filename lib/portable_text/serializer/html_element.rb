require_relative "base"

module PortableText
  module Serializer
    class HTMLElement < Base
      def initialize(tag)
        @tag = tag
      end

      def call(inner_html)
        "<#{@tag}>#{inner_html}</#{@tag}>"
      end
    end
  end
end