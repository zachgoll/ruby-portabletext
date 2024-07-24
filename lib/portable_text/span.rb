require_relative "renderable"

module PortableText
  class Span
    include Renderable

    class << self
      def from_json(json, mark_defs)
        type = json["_type"]
        text = json["text"]
        marks = (json["marks"] || []).map { |mark_key| Mark.from_key(mark_key, mark_defs) }

        serializer = PortableText.configuration.serializer_registry.get(type, fallback: "span")

        new \
          serializer: serializer,
          attributes: {
            type: type,
            text: text,
            marks: marks,
          },
          raw_json: json.merge("_internal" => { "inline" => true })
      end
    end

    attr_reader :text
    attr_accessor :marks

    def initialize(attributes: {}, raw_json: {}, serializer:)
      @type = attributes[:type]
      @text = attributes[:text]
      @marks = attributes[:marks]
      @raw_json = raw_json
      @serializer = serializer
    end

    def to_html
      @serializer.call(text, @raw_json)
    end
  end
end