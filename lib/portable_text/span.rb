module PortableText
  class Span
    def initialize(type:, text:, marks:, raw_json:)
      @type = type
      @text = text
      @marks = marks
      @raw_json = raw_json
    end
  end
end