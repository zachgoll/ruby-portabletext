require_relative "annotation/link"
require_relative "annotation/highlight"
require_relative "annotation/unknown"
require_relative "decorator"

class Child
  attr_reader :type, :text, :marks, :project_id, :dataset, :data
  attr_accessor :prev_child, :next_child

  def initialize(json, marks, project_id, dataset, next_child: nil, prev_child: nil)
    @data = json
    @type = json["_type"]
    @text = json["text"]
    @marks = marks
    @project_id = project_id
    @dataset = dataset
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
    output_html = ""
    output_html += open_marks

    case type
    when "span"
      output_html += escape_html_string(text)
    when "image"
      output_html += Image.new(data, project_id, dataset, render_figure: false).to_html
    else
      output_html += custom_type(type, escape_html_string(text))
    end

    output_html += close_marks
    output_html
  end

  private

    def custom_type(type, content)
      "<#{type}>#{content}</#{type}>"
    end

    def escape_html_string(html_string)
      map = {
        "'" => "&#x27;",
        "\n" => "<br/>",
        "\"" => "&quot;"
      }

      pattern = Regexp.union(map.keys)

      html_string.gsub(pattern) do |match|
        map[match]
      end
    end

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