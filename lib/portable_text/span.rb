require_relative "renderable"

module PortableText
  class Span
    include Renderable

    class << self
      def from_json(json, mark_defs)
        text = json["text"]
        marks = json["marks"].map { |mark_key| Mark.from_key(mark_key, mark_defs) }

        new \
          attributes: {
            text: text,
            marks: marks,
          },
          raw_json: json
      end
    end

    attr_reader :text
    attr_accessor :marks

    def initialize(attributes: {}, raw_json: {})
      @text = attributes[:text]
      @marks = attributes[:marks]
      @raw_json = raw_json
    end

    def to_html
      escape_html_string(text)
    end

    private
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
  end
end