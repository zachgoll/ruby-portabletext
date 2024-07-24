module PortableText
  class Renderer

    def render(input)
      blocks = parser.parse(input)
      html = blocks.map(&:to_html).join

      return html if blocks.length <= 1

      serializer.call(html)
    end

    private
      def parser
        @parser ||= Parser.new
      end

      def serializer
        Serializer::HTMLElement.new("div")
      end
  end
end