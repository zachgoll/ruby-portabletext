require_relative "base"

module PortableText
  module Serializer
    class Span < Base
      def call(inner_html, _data = nil)
        escape_html_string(inner_html)
      end

      private

        def escape_html_string(html_string)
          map = {
            "'" => "&#x27;",
            "\n" => "<br/>",
            "\"" => "&quot;"
          }

          pattern = Regexp.union(map.keys)

          html_string.gsub(pattern) do |match|
            map[match]
          end
        end
    end
  end
end