require_relative "annotation/link"
require_relative "annotation/highlight"
require_relative "decorator"

class Child
  attr_reader :type, :text, :marks
  attr_accessor :prev_child, :next_child

  def initialize(type, text, marks, next_child: nil, prev_child: nil)
    @type = type
    @text = text
    @marks = marks
    @next_child = next_child
    @prev_child = prev_child
  end

  def has_mark?(mark)
    marks.select { |m| m.key == mark.key }.length > 0
  end

  def missing_mark?(mark)
    !has_mark?(mark)
  end

  def to_html
    open_marks + text + close_marks
  end

  private

    def open_marks
      sorted_marks.reduce("") do |html, mark|
        if prev_child.nil? || prev_child&.missing_mark?(mark)
          html += mark.open
        end

        html
      end
    end

    def close_marks
      sorted_marks.reverse.reduce("") do |html, mark|
        if next_child.nil? || next_child&.missing_mark?(mark)
          html += mark.close
        end

        html
      end
    end

    def render_tag(tag, content)
      "<#{tag}>#{content}</#{tag}>"
    end

    def mark_frequencies
      counts = {}

      marks.each do |mark|
        counts[mark.key] = 1

        next_child_in_iteration = next_child

        while next_child_in_iteration&.has_mark?(mark)
          counts[mark.key] += 1
          next_child_in_iteration = next_child_in_iteration.next_child
        end
      end

      counts
    end

    def sorted_marks
      Mark.sorted(marks, mark_frequencies)
    end
end