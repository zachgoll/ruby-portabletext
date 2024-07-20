class Mark
  attr_reader :key

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
        Decorator.sort_marks(mark_a, mark_b)
      end

      # Attempts to sort by the first non-zero result
      def handle_sort_results(results)
        results.each do |result|
          return result unless result.zero?
        end
      end
  end

  def initialize(key)
    @key = key
  end

  def open
    raise NotImplementedError
  end

  def close
    raise NotImplementedError
  end

  def sort_score
    raise NotImplementedError
  end
end