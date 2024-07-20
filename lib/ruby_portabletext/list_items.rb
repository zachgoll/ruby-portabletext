class TreeNode
  TAG_MAP = { "bullet" => "ul", "number" => "ol" }

  attr_accessor :block, :children

  class << self
    def opening_tag(list_type)
      "<#{TAG_MAP[list_type]}>"
    end

    def closing_tag(list_type)
      "</#{TAG_MAP[list_type]}>"
    end
  end

  def initialize(block)
    @block = block
    @children = []
  end

  def style_tag
    unless block.style == "normal"
      block.get_tag
    end
  end

  def to_html
    html = "<li>"
    html += "<#{style_tag}>" if style_tag
    html += "#{self.block.to_html}"

    if self.children.any?
      list_tag = TAG_MAP[self.children.first.block.list_item]

      html += "<#{list_tag}>"

      self.children.each do |child|
        html += child.to_html
      end

      html += "</#{list_tag}>"
    end

    html += "</#{style_tag}>" if style_tag
    html += "</li>"
    html
  end
end

class ListItems
  def initialize(blocks)
    @blocks = blocks
  end

  def to_html
    tree = build_tree
    html = ""

    last_known_outer_tag = tree.first.block.list_item
    html += TreeNode.opening_tag(last_known_outer_tag)

    tree.each do |node|
      if last_known_outer_tag && node.block.list_item == last_known_outer_tag
        html << node.to_html
      else
        # Close previous, open new list
        html << TreeNode.closing_tag(last_known_outer_tag)
        html << TreeNode.opening_tag(node.block.list_item)

        # Update last observed list tag
        last_known_outer_tag = node.block.list_item

        html << node.to_html
      end
    end

    html += TreeNode.closing_tag(last_known_outer_tag)
    html
  end

  private
    def build_tree
      root = []
      stack = []

      @blocks.each do |block|
        node = TreeNode.new(block)

        # Determine if we need to pop items from the stack
        while !stack.empty? && (stack.last.block.level >= block.level)
          stack.pop
        end

        # Append the node to the appropriate parent or to the root
        if stack.empty?
          root << node
        else
          stack.last.children << node
        end

        # Push the current node onto the stack
        stack << node
      end

      root
    end
end