require_relative "renderable"

module PortableText
  class Span
    include Renderable

    attr_reader :text
    attr_accessor :marks

    def initialize(attributes: {}, raw_json: {})
      @text = attributes[:text]
      @marks = attributes[:marks]
      @raw_json = raw_json
    end

    def to_html
      text
    end

    def has_mark?(mark)
      marks.include?(mark)
    end
  end
end