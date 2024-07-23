require "test_helper"

class RendererTest < Minitest::Test
  test "can configure" do
    PortableText.configure do |config|
      config.project_id = "test"
      config.dataset = "test"
      config.serializers = { test: ->(data) { "test" } }
    end

    assert_equal "test", PortableText.configuration.project_id
    assert_equal "test", PortableText.configuration.dataset
    assert PortableText.configuration.serializers[:test]
  end
end