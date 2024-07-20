require_relative "children"
require_relative "mark_def"

class Block
  attr_reader :key, :type, :children, :style, :mark_defs, :list_item, :level

  def initialize(json)
    @key = json["_key"]
    @type = json["_type"]
    @style = json["style"]
    @children = Children.new(json["children"], json["markDefs"])
    @list_item = json["listItem"]
    @level = json["level"] || 1
  end

  def to_html
    output = ""

    if list_item
      output += children.to_html
    else
      output += render_tag(get_tag, children.to_html)
    end

    output
  end

  def render_tag(tag, content)
    "<#{tag}>#{content}</#{tag}>"
  end

  def get_tag
    # return "li" if list_item
    # return "p" if style.nil?

    map = {
      "normal" => "p",
      "h1" => "h1",
      "h2" => "h2",
      "h3" => "h3",
      "h4" => "h4",
      "h5" => "h5",
      "h6" => "h6",
      "blockquote" => "blockquote",
      "code" => "code",
    }

    map[style]
  end
end