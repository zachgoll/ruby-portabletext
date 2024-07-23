require_relative "../test_helper"
require_relative "./interface_test"
class PortableText::Serializer::HTMLElementTest < Minitest::Test
  include SerializerInterfaceTest

  def setup
    @object = PortableText::Serializer::HTMLElement.new("p")
  end
end