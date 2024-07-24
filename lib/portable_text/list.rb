require_relative 'renderable'

module PortableText
    class List
      include Renderable

      def initialize(list_items, serializer_registry)
        @list_items = list_items
        @serializer_registry = serializer_registry
        @serializer = get_serializer_from_registry(list_items, serializer_registry)
      end

      def to_html
        start_level = list_items.first.list_level || 1

        chunks = list_items.chunk_while do |li1, li2|
          li1.list_level > start_level && li2.list_level > start_level
        end.to_a

        items = chunks.map { |chunk| render_chunk(chunk) }.join

        @serializer.call(items)
      end

      private
        attr_reader :list_items, :serializer, :serializer_registry

        def render_chunk(chunk)
          if chunk.size == 1
            chunk.first.to_html
          else
            List.new(chunk, serializer_registry).to_html
          end
        end

        def get_serializer_from_registry(items, registry)
          serializer_key = items.first&.list_type == "numbered" ? "ol" : "ul"
          serializer = registry.get(serializer_key)

          raise UnknownTypeError.new("#{serializer_key} not available in serializer registry") unless serializer

          serializer
        end
    end
end