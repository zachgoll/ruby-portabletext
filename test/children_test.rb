require_relative "test_helper"

class PortableText::ChildrenTest < Minitest::Test

  class MockHtmlSerializer < PortableText::Serializer::Base
    def initialize(key)
      @key = key
    end

    def call(inner_html, data = nil)
      "<#{@key}>#{inner_html}</#{@key}>"
    end
  end

  class MockCustomSerializer < PortableText::Serializer::Base
    def call(inner_html, data)
      href = data["href"]

      "<a href=\"#{href}\">#{inner_html}</a>"
    end
  end

  def setup
    custom_mark_def = PortableText::MarkDef.new("custom_mark", raw_json: { "href" => "#test" })
    @custom_mark = PortableText::Mark.new(key: "custom_mark", definition: custom_mark_def, serializer: MockCustomSerializer.new)
    @strong_mark = PortableText::Mark.new(key: "strong", serializer: MockHtmlSerializer.new("strong"))
    @em_mark = PortableText::Mark.new(key: "em", serializer: MockHtmlSerializer.new("em"))
  end

  test "renders list of spans" do
    child1 = create_child(attributes: { marks: [], text: "one" })
    child2 = create_child(attributes: { marks: [], text: "two" })
    children = PortableText::Children.new([child1, child2])
    assert_equal "onetwo", children.to_html
  end

  test "renders with decorator marks" do
    child1 = create_child(attributes: { marks: [@strong_mark], text: "one" })
    child2 = create_child(attributes: { marks: [], text: "two" })
    children = PortableText::Children.new([child1, child2])
    assert_equal "<strong>one</strong>two", children.to_html
  end

  test "consecutive but different marks" do
    child1 = create_child(attributes: { marks: [@strong_mark], text: "one" })
    child2 = create_child(attributes: { marks: [@em_mark], text: "two" })
    children = PortableText::Children.new([child1, child2])
    assert_equal "<strong>one</strong><em>two</em>", children.to_html
  end

  test "renders with overlapping decorator marks" do
    child1 = create_child(attributes: { marks: [@strong_mark], text: "A word of " })
    child2 = create_child(attributes: { marks: [@em_mark, @strong_mark], text: "warning;" })
    child3 = create_child(attributes: { marks: [@strong_mark], text: " Sanity is addictive." })
    child4 = create_child(attributes: { marks: [], text: " have " })
    child5 = create_child(attributes: { marks: [@em_mark], text: "fun!" })
    children = PortableText::Children.new([child1, child2, child3, child4, child5])
    assert_equal "<strong>A word of <em>warning;</em> Sanity is addictive.</strong> have <em>fun!</em>", children.to_html
  end

  test "renders with annotations" do
    child1 = create_child(attributes: { marks: [@custom_mark], text: "one" })
    child2 = create_child(attributes: { marks: [], text: "two" })
    children = PortableText::Children.new([child1, child2])
    assert_equal "<a href=\"#test\">one</a>two", children.to_html
  end

  test "renders with overlapping decorators and annotations" do
    child1 = create_child(attributes: { marks: [@strong_mark], text: "A word of " })
    child2 = create_child(attributes: { marks: [@em_mark, @strong_mark], text: "warning;" })
    child3 = create_child(attributes: { marks: [@strong_mark, @custom_mark], text: " Sanity is addictive." })
    child4 = create_child(attributes: { marks: [], text: " have " })
    child5 = create_child(attributes: { marks: [@em_mark], text: "fun!" })
    children = PortableText::Children.new([child1, child2, child3, child4, child5])
    assert_equal "<strong>A word of <em>warning;</em><a href=\"#test\"> Sanity is addictive.</a></strong> have <em>fun!</em>", children.to_html
  end

  test "renders inline blocks" do
    class MockImageSerializer < PortableText::Serializer::Base
      def call(inner_html, data)
        ref = data["asset"]["_ref"]
        "<mock-image>#{ref}</mock-image>"
      end
    end

    child1 = create_child(attributes: { marks: [@strong_mark], text: "one" })
    child2 = create_child(type: "image", serializer: MockImageSerializer.new,
                          attributes: { type: "image", },
                          raw_json: { "asset" => { "_type" => "reference", "_ref" => "image-YiOKD0O6AdjKPaK24WtbOEv0-3456x2304-jpg" } })
    children = PortableText::Children.new([child1, child2])
    assert_equal "<strong>one</strong><mock-image>image-YiOKD0O6AdjKPaK24WtbOEv0-3456x2304-jpg</mock-image>", children.to_html
  end
end