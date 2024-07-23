module PortableText
  class Mark
    KNOWN_TYPES = %w[ strong em code underline strike-through ]

    class << self
      def sorted(marks, mark_frequencies)
        marks.sort do |a, b|

          # The first non-zero comparison will be the sort
          sorting_queue = [
            sort_by_frequency(a, b, mark_frequencies),
            sort_by_type(a, b),
            sort_by_decorator(a, b)
          ]

          handle_sort_results(sorting_queue) || a.key <=> b.key
        end
      end

      private

        def sort_by_type(mark_a, mark_b)
          mark_a.sort_score <=> mark_b.sort_score
        end

        def sort_by_frequency(mark_a, mark_b, frequencies)
          frequencies[mark_a.key] * -1 <=> frequencies[mark_b.key] * -1
        end

        def sort_by_decorator(mark_a, mark_b)
          default_idx = KNOWN_TYPES.length

          a_index = KNOWN_TYPES.index(mark_a.key) || default_idx
          b_index = KNOWN_TYPES.index(mark_b.key) || default_idx

          a_index <=> b_index
        end

        # Attempts to sort by the first non-zero result
        def handle_sort_results(results)
          results.each do |result|
            return result unless result.zero?
          end
          nil
        end
    end

    def initialize(key:, definition: nil)
      @key = key
      @definition = definition
    end

    def decorator?
      KNOWN_TYPES.include?(key)
    end

    private
      attr_reader :key
  end
end