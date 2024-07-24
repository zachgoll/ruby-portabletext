require_relative 'renderable'

module PortableText
    class List
      include Renderable

      class << self
        def list_item?(json)
          json.key?("listItem")
        end
      end

      def initialize(list_items)
        @list_items = list_items
      end

      def to_html
        start_level = list_items.first.list_level || 1

        chunks = list_items.chunk_while do |li1, li2|
          li2.list_level > start_level
        end.to_a

        items = chunks.map { |chunk| render_chunk(chunk) }.join

        serializer.call(items)
      end

      private
        attr_reader :list_items

        def serializer
          serializer_key = list_items.first&.list_type == "number" ? "ol" : "ul"
          serializer = PortableText.configuration.serializer_registry.get(serializer_key)

          raise UnknownTypeError.new("#{serializer_key} not available in serializer registry") unless serializer

          serializer
        end

        def render_chunk(chunk)
          if chunk.size == 1
            chunk.first.to_html
          else
            wrap_sub_list(chunk.first, List.new(chunk.drop(1)))
          end
        end

        def wrap_sub_list(block, sub_list)
          "<li>" + block.children.to_html + sub_list.to_html + "</li>"
        end
    end
end