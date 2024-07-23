require_relative "base"

module PortableText
  module Serializer
    class Underline < Base
      def call(inner_html)
        "<span style=\"text-decoration:underline;\">#{inner_html}</span>"
      end
    end
  end
end