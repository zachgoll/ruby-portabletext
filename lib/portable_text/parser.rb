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
        last_started_list_type = nil
        elements.chunk_while do |e1, e2|
          if List.list_item?(e1) && List.list_item?(e2)
            last_started_list_type = e1["listItem"] if last_started_list_type.nil?

            if e2["level"] > 1 || (e2["level"] == 1 && e2["listItem"] == last_started_list_type)
              true
            else
              last_started_list_type = e2["listItem"]
              false
            end
          else
            last_started_list_type = nil
            false
          end
        end
      end

      def list_items?(e1, e2)
        List.list_item?(e1) && List.list_item?(e2)
      end

      def create_list(elements)
        blocks = elements.map { |e| Block.from_json(e) }
        List.new(blocks)
      end
  end
end