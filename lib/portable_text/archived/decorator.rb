require_relative "mark"

class Decorator < Mark
  SORTED_KEYS = %w[ strong em code underline strike-through ]

  class << self
    def sort_marks(mark_a, mark_b)
      sorted_keys = %w[ strong em code underline strike-through ]

      a_index = sorted_keys.index(mark_a.key) || sorted_keys.length
      b_index = sorted_keys.index(mark_b.key) || sorted_keys.length

      a_index <=> b_index
    end

    def is_decorator_key?(key)
      SORTED_KEYS.include?(key)
    end
  end

  def open
    case key
    when "strike-through"
      "<del>"
    when "underline"
      "<span style=\"text-decoration:underline;\">"
    else
      "<#{key}>"
    end
  end

  def close
    case key
    when "strike-through"
      "</del>"
    when "underline"
      "</span>"
    else
      "</#{key}>"
    end
  end

  def sort_score
    1
  end
end