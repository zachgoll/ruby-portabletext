require_relative "renderable"

module PortableText
  class Children
    include Renderable

    class << self
      def from_json(items, mark_defs)
        defs = mark_defs.map { |md| MarkDef.from_json(md) }

        parsed_items = items.map do |item|
          if item["_type"] == "span"
            Span.from_json(item, defs)
          else
            Block.from_json(item)
          end
        end

        new parsed_items, raw_json: items
      end
    end

    def initialize(elements = [], raw_json: {})
      @elements = elements
      @raw_json = raw_json
    end

    def to_html
      chunk_and_render(elements)
    end

    private

      attr_reader :elements, :raw_json

      def chunk_and_render(elements)
        chunks = Mark.chunk_by_marks(elements)
        chunks.map { |chunk| render_chunk(chunk) }.join
      end

      def render_chunk(chunk)
        if chunk.size == 1 && chunk.first.marks.empty?
          chunk.first.to_html
        else
          outer_mark = Mark.outermost_mark(chunk)
          inner_html = chunk_and_render(nodes_without_outer_mark(chunk, outer_mark.key))
          outer_mark.serialize(inner_html)
        end
      end

      def nodes_without_outer_mark(nodes, mark_key)
        nodes.map do |node|
          new_node = node.dup
          new_node.marks = new_node.marks.reject { |mark| mark.key == mark_key }
          new_node
        end
      end
  end
end