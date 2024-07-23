require_relative "test_helper"
require_relative "renderable_interface_test"
class PortableText::ListTest < Minitest::Test
  include RenderableInterfaceTest

  def setup
    @object = PortableText::List.new([])
  end
end