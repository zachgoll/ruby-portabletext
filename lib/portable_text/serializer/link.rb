require_relative "base"

module PortableText
  module Serializer
    class Link < Base

      def call(inner_html, data = nil)
        "<a href=\"#{data["href"]}\">#{inner_html}</a>"
      end
    end
  end
end