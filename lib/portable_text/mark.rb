module PortableText
  class Mark
    KNOWN_TYPES = %w[ strong em code underline strike-through ]

    class << self

      def from_key(key, mark_defs)
        definition = mark_defs.find { |md| md.key == key }

        serializer_key = definition ? definition.type : key
        serializer = PortableText.configuration.serializer_registry.get(serializer_key, fallback: "missing_mark", ctx: mark_defs)

        new \
          key: key,
          serializer: serializer,
          definition: definition
      end

      def chunk_by_marks(nodes)
        # nodes.chunk_while { |e1, e2| e1.marks.any? && e2.marks.any? }
        nodes.chunk_while do |e1, e2|
          e1_mark_keys = e1.marks.map(&:key)
          e2_mark_keys = e2.marks.map(&:key)

          (e1_mark_keys & e2_mark_keys).any?
        end
      end

      # Finds the outermost mark in a "chunk" of spans
      # Ties are broken based on whether the mark key is known (decorator) or unknown (annotation)
      def outermost_mark(nodes)
        all_marks = nodes.flat_map(&:marks)
        mark_counts = all_marks.group_by(&:key).transform_values(&:count)
        return nil if mark_counts.empty?

        max_count = mark_counts.values.max

        most_frequent_marks = mark_counts.select { |_, count| count == max_count }

        if most_frequent_marks.size > 1
          unknown_mark_keys = most_frequent_marks.keys - Mark::KNOWN_TYPES
          if unknown_mark_keys.any?
            all_marks.find { |mark| mark.key == unknown_mark_keys.first }
          else
            sorted_keys = most_frequent_marks.keys.sort_by { |key| Mark::KNOWN_TYPES.index(key) || Float::INFINITY }
            all_marks.find { |mark| mark.key == sorted_keys.first }
          end
        else
          all_marks.find { |mark| mark.key == most_frequent_marks.keys.first }
        end
      end
    end

    attr_reader :key, :serializer, :definition

    def initialize(key:, serializer:, definition: nil)
      @key = key
      @serializer = serializer
      @definition = definition
    end

    def serialize(inner_html)
      serializer.call(inner_html, definition&.raw_json)
    end
  end
end