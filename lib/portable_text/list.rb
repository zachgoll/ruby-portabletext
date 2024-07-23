require_relative 'renderable'

module PortableText
    class List
      include Renderable

      def initialize(list_items, serializer)
        @list_items = list_items
        @serializer = serializer
      end

      def to_html
        @serializer.call(chunk_and_render(list_items))
      end

      private
        attr_reader :list_items

        def chunk_and_render(list_items)
          chunks = list_items.chunk_while do |li1, li2|
            li1.list_level < li2.list_level
          end

          chunks.map { |chunk| render_chunk(chunk) }.join
        end

        def render_chunk(chunk)
          if chunk.size == 1
            chunk.first.to_html
          else
            sub_items = chunk_and_render(chunk)
            "<ul>#{sub_items}</ul>"
          end
        end
    end
end