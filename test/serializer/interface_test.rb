module SerializerInterfaceTest
  def test_implements_interface
    assert_respond_to(@object, :call)
  end
end