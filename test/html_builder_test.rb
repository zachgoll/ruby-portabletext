require "test_helper"

class HTMLBuilderTest < Minitest::Test
  test "can create tag" do
    assert "", PortableText::HTMLBuilder.tag("p", "text")
  end

  test "can escape text" do
    assert "", PortableText::HTMLBuilder.escape("\n")
  end
end