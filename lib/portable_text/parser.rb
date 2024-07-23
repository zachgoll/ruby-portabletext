module PortableText
  class UnknownTypeError < StandardError
  end

  class Parser
    def initialize(json, serializer_registry)
      @json = json
      @serializer_registry = serializer_registry
    end

    def parsed
      elements = ensure_array(json)

      create_chunks(elements).map do |chunk|
        if list_item?(chunk.first)
          create_list(chunk)
        else
          create_block(chunk.first)
        end
      end
    end

    private

      attr_reader :json, :serializer_registry

      def ensure_array(input)
        input.is_a?(Array) ? input : [input]
      end

      # Adjacent list items need to be "chunked" into a single list, while blocks are standalone
      def create_chunks(elements)
        elements.chunk_while do |e1, e2|
          if list_item?(e1) && list_item?(e2)
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

      def list_item?(element)
        element.key?("listItem")
      end

      def create_block(element)
        key = element["_key"]
        type = element["_type"]
        style = element["style"]
        list_level = element["level"]
        list_type = element["listItem"]

        mark_defs = (element["markDefs"] || []).map { |md| PortableText::MarkDef.new md["_type"], raw_json: md }
        children = create_children(element["children"] || [], mark_defs)

        serializer = serializer_registry.get(type, style)

        raise UnknownTypeError.new("#{type} is not defined in serializers registry") unless serializer

        PortableText::Block.new \
          serializer: serializer,
          attributes: {
            key: key,
            type: type,
            style: style,
            list_level: list_level,
            list_type: list_type,
            children: children,
          },
          raw_json: element
      end

      def create_list(elements)
        blocks = elements.map { |e| create_block(e) }

        serializer_key = blocks.first.list_type == "numbered" ? "ol" : "ul"

        serializer = serializer_registry.get(serializer_key)
        raise UnknownTypeError.new("#{serializer_key} is not defined in serializers registry") unless serializer

        PortableText::List.new(blocks, serializer)
      end

      def create_children(elements, mark_definitions)
        parsed_elements = elements.map do |element|
          if element["_type"] == "span"
            create_span(element, mark_definitions)
          else
            create_block(element)
          end
        end

        PortableText::Children.new parsed_elements, raw_json: elements
      end

      def create_span(element, mark_definitions)
        text = element["text"]
        mark_keys = element["marks"]
        marks = mark_keys.map { |mk| create_mark(mk, mark_definitions) }

        PortableText::Span.new \
          attributes: {
            text: text,
            marks: marks,
          },
          raw_json: element
      end

      def create_mark(key, mark_definitions)
        definition = mark_definitions.find { |md| md["_key"] == key }

        serializer_key = definition ? definition.type : key
        serializer = serializer_registry.get(serializer_key)

        raise UnknownTypeError.new("#{serializer_key} is not defined in serializers registry") unless serializer

        PortableText::Mark.new \
          key: key,
          serializer: serializer,
          definition: definition
      end
  end
end