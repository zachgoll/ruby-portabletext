require_relative "test_helper"
require_relative "./renderable_interface_test"
class PortableText::BlockTest < Minitest::Test
  include RenderableInterfaceTest

  def setup
    @object = PortableText::Block.new \
      attributes: {
        key: "test",
        type: "test",
        style: "test",
        children: []
      },
      serializer: PortableText::Serializer::HTMLElement.new("p"),
      raw_json: {}
  end
end