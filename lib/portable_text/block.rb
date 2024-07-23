require_relative "mark"
require_relative "span"
require_relative "children"
require_relative "renderable"

module PortableText
  class Block
    include Renderable
    def initialize(key:, type:, style:, children:, raw_json:, list_level: nil, list_type: nil)
      @key = key
      @type = type
      @style = style
      @children = children
      @raw_json = raw_json
      @list_level = list_level
      @list_type = list_type
    end
  end
end