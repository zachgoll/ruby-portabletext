require_relative "base"

module PortableText
  module Serializer
    class HTMLElement < Base
      def initialize(tag)
        @tag = tag
      end

      def call(data)
        ""
      end
    end
  end
end