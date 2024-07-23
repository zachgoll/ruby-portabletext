require_relative "renderable"
require_relative "children"
require_relative "mark_def"

class BlockArchived < Renderable
  attr_reader :key, :type, :children, :style, :mark_defs, :list_item, :level, :project_id, :dataset

  def initialize(json, project_id, dataset)
    @project_id = project_id
    @dataset = dataset
    @key = json["_key"]
    @type = json["_type"]
    @style = json["style"]
    @children = Children.new(json["children"], json["markDefs"] || [], project_id, dataset)
    @list_item = json["listItem"]
    @level = json["level"] || 1
  end

  def to_html
    output = ""

    tag = style.nil? ? "p" : get_tag

    if list_item
      output += children.to_html
    else
      output += render_tag(tag, children.to_html)
    end

    output
  end

  def render_tag(tag, content)
    "<#{tag}>#{content}</#{tag}>"
  end

  def get_tag
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