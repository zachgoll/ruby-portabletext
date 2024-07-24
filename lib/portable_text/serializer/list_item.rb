require_relative "base"

module PortableText
  module Serializer
    class ListItem < Base
      def call(inner_html, data)
        list_tag(with_styles(inner_html, data["style"]))
      end

      private

        def with_styles(inner_html, style)
          if style && style != "normal"
            apply_styles(inner_html, style)
          else
            inner_html
          end
        end

        def apply_styles(text, style)
          "<#{style}>#{text}</#{style}>"
        end

        def list_tag(inner_html)
          "<li>#{inner_html}</li>"
        end
    end
  end
end