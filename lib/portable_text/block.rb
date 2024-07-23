require_relative "mark"
require_relative "mark_def"
require_relative "span"
require_relative "children"
require_relative "renderable"

module PortableText
  class Block
    include Renderable

    attr_reader :list_level, :list_type, :children

    def initialize(serializer:, attributes: {}, raw_json: {})
      @serializer = serializer
      @raw_json = raw_json
      @key = attributes[:key]
      @type = attributes[:type]
      @style = attributes[:style]
      @mark_defs = attributes[:mark_defs]
      @children = attributes[:children]
      @list_level = attributes[:list_level]
      @list_type = attributes[:list_type]
    end

    def to_html
      rendered_children = children ? children.to_html : ""
      @serializer.call(rendered_children, @raw_json)
    end

    def marks
      []
    end
  end
end