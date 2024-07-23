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
    @object = PortableText::List.new([], {})
  end

  test "renders basic list" do
    items = [
      create_list_item("bullet", 1, "first"),
      create_list_item("bullet", 1, "second"),
      create_list_item("bullet", 1, "third"),
    ]

    list = PortableText::List.new(items, MockListSerializer.new("ul"))

    assert_equal "<ul><li>first</li><li>second</li><li>third</li></ul>", list.to_html
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
        serializer: MockListSerializer.new("li")
    end
end