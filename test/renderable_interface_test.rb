module RenderableInterfaceTest
  def test_implements_interface
    assert_respond_to(@object, :to_html)
  end
end