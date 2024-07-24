require_relative "base"

module PortableText
  module Serializer
    class Image < Base
      def initialize(base_url)
        @base_url = base_url
      end

      def call(_inner_html, data)
        src = image_url(data)
        if data.dig("_internal", "inline")
          image_html(src)
        else
          figure_html(image_html(src))
        end
      end

      private

        def image_html(src)
          "<img src=\"#{src}\"/>"
        end

        def image_url(data)
          return data["asset"]["url"] if data["asset"]["url"]

          parts = image_parts(data["asset"]["_ref"])
          id = parts[0]
          dimensions = parts[1]
          ext = parts[2]

          "#{@base_url}/#{id}-#{dimensions}.#{ext}"
        end

        def image_parts(image_ref)
          @image_parts ||= image_ref.split("-").drop(1)
        end

        def figure_html(inner_html)
          "<figure>#{inner_html}</figure>"
        end
    end
  end
end