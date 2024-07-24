module PortableText
  class UnknownTypeError < StandardError
  end

  class Parser
    def parse(json)
      elements = ensure_array(json)

      create_chunks(elements).map do |chunk|
        if List.list_item?(chunk.first)
          create_list(chunk)
        else
          Block.from_json(chunk.first)
        end
      end
    end

    private

      attr_reader :serializer_registry

      def ensure_array(input)
        input.is_a?(Array) ? input : [input]
      end

      # Adjacent list items need to be "chunked" into a single list, while blocks are standalone
      def create_chunks(elements)
        elements.chunk_while do |e1, e2|
          if List.list_item?(e1) && List.list_item?(e2)
            !list_type_changes?(e1, e2)
          else
            false
          end
        end
      end

      def list_type_changes?(list_item_1, list_item_2)
        list_item_1["level"] == 1 &&
          list_item_2["level"] == 1 &&
          list_item_1["listItem"] != list_item_2["listItem"]
      end

      def create_list(elements)
        blocks = elements.map { |e| Block.from_json(e) }
        List.new(blocks)
      end
  end
end