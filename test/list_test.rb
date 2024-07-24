require_relative "test_helper"
require_relative "renderable_interface_test"

class PortableText::ListTest < Minitest::Test
  include RenderableInterfaceTest

  class MockListSerializer < PortableText::Serializer::Base
    def initialize(tag)
      @tag = tag
    end

    def call(inner_html, data = nil)
      "<#{@tag}>#{inner_html}</#{@tag}>"
    end
  end

  def setup
    @object = PortableText::List.new([])
  end

  test "renders basic list" do
    items = [
      create_list_item("bullet", 1, "first"),
      create_list_item("bullet", 1, "second"),
      create_list_item("bullet", 1, "third"),
    ]

    list = PortableText::List.new(items)

    assert_equal "<ul><li>first</li><li>second</li><li>third</li></ul>", list.to_html
  end

  test "renders nested list" do
    # - 1a
    #   - 2a
    #   - 2b
    #      - 3a
    #      - 3b
    # - 1b
    # - 1c
    items = [
      create_list_item("bullet", 1, "1a"),
      create_list_item("bullet", 2, "2a"),
      create_list_item("bullet", 2, "2b"),
      create_list_item("bullet", 3, "3a"),
      create_list_item("bullet", 3, "3b"),
      create_list_item("bullet", 1, "1b"),
      create_list_item("bullet", 1, "1c"),
    ]

    list = PortableText::List.new(items)

    assert_equal "<ul><li>1a<ul><li>2a</li><li>2b<ul><li>3a</li><li>3b</li></ul></li></ul></li><li>1b</li><li>1c</li></ul>", list.to_html
  end

  private

    def create_list_span(text)
      PortableText::Span.new(attributes: { text: text, marks: [] })
    end

    def create_list_item(type, level, text)
      PortableText::Block.new \
        attributes: {
          list_level: level,
          list_type: type,
          children: PortableText::Children.new([create_list_span(text)])
        },
        raw_json: {},
        serializer: PortableText::Serializer::HTMLElement.new("li")
    end
end