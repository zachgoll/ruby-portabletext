require_relative "child"

class Children
  attr_reader :children

  def initialize(children_json, mark_defs_json)
    @children = create_child_blocks(children_json, mark_defs_json)
  end

  def to_html
    children.map(&:to_html).join
  end

  private

    def create_child_blocks(children_json, mark_defs_json)
      mark_defs = mark_defs_json.map { |md| MarkDef.new(md) }

      children = children_json.map do |child_json|
        marks = create_marks(child_json["marks"], mark_defs)
        Child.new(child_json["_type"], child_json["text"], marks)
      end

      children.each_with_index.map do |child, idx|
        prev_child = children[idx - 1] if idx > 0
        next_child = children[idx + 1] if idx + 1 < children.size

        child.prev_child = prev_child
        child.next_child = next_child
      end

      children
    end

    def create_marks(mark_keys, mark_defs)
      combined_marks = []

      mark_keys.each do |mark_key|
        mark_def = mark_defs.find { |md| md.key == mark_key }

        if mark_def
          case mark_def.type
          when "highlight"
            combined_marks << Annotation::Highlight.new(mark_key, mark_def.attributes)
          when "link"
            combined_marks << Annotation::Link.new(mark_key, mark_def.attributes)
          else
            raise "Unrecognized mark_def type: #{mark_def.type}"
          end
        else
          combined_marks << Decorator.new(mark_key)
        end
      end

      combined_marks
    end
end