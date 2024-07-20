require "test_helper"

class RendererTest < Minitest::Test
  def setup
    @renderer = RubyPortabletext::Renderer.new("3do82whm", "production")
  end

  test "001-empty-block" do
    json_data = read_json_file("001-empty-block.json")
    assert_rendered_result(json_data)
  end

  test "002-single-span" do
    json_data = read_json_file("002-single-span.json")
    assert_rendered_result(json_data)
  end

  test "003-multiple-spans" do
    json_data = read_json_file("003-multiple-spans.json")
    assert_rendered_result(json_data)
  end

  test "004-basic-mark-single-span" do
    json_data = read_json_file("004-basic-mark-single-span.json")
    assert_rendered_result(json_data)
  end

  test "005-basic-mark-multiple-adjacent-spans" do
    json_data = read_json_file("005-basic-mark-multiple-adjacent-spans.json")
    assert_rendered_result(json_data)
  end

  test "006-basic-mark-nested-marks" do
    json_data = read_json_file("006-basic-mark-nested-marks.json")
    assert_rendered_result(json_data)
  end

  test "007-link-mark-def" do
    json_data = read_json_file("007-link-mark-def.json")
    assert_rendered_result(json_data)
  end

  test "008-plain-header-block" do
    json_data = read_json_file("008-plain-header-block.json")
    assert_rendered_result(json_data)
  end

  test "009-messy-link-text" do
    json_data = read_json_file("009-messy-link-text.json")
    assert_rendered_result(json_data)
  end

  test "010-basic-bullet-list" do
    json_data = read_json_file("010-basic-bullet-list.json")
    assert_rendered_result(json_data)
  end

  test "011-basic-numbered-list" do
    json_data = read_json_file("011-basic-numbered-list.json")
    assert_rendered_result(json_data)
  end

  test "012-image-support" do
    json_data = read_json_file("012-image-support.json")
    assert_rendered_result(json_data)
  end

  test "013-materialized-image-support" do
    json_data = read_json_file("013-materialized-image-support.json")
    assert_rendered_result(json_data)
  end

  test "014-nested-lists" do
    json_data = read_json_file("014-nested-lists.json")
    assert_rendered_result(json_data)
  end

  test "015-all-basic-marks" do
    json_data = read_json_file("015-all-basic-marks.json")
    assert_rendered_result(json_data)
  end

  test "016-deep-weird-lists" do
    json_data = read_json_file("016-deep-weird-lists.json")
    assert_rendered_result(json_data)
  end

  test "017-all-default-block-styles" do
    json_data = read_json_file("017-all-default-block-styles.json")
    assert_rendered_result(json_data)
  end

  test "018-marks-all-the-way-down" do
    json_data = read_json_file("018-marks-all-the-way-down.json")
    assert_rendered_result(json_data)
  end

  test "019-keyless" do
    json_data = read_json_file("019-keyless.json")
    assert_rendered_result(json_data)
  end

  test "020-empty-array" do
    json_data = read_json_file("020-empty-array.json")
    assert_rendered_result(json_data)
  end

  test "021-list-without-level" do
    json_data = read_json_file("021-list-without-level.json")
    assert_rendered_result(json_data)
  end

  test "022-inline-nodes" do
    json_data = read_json_file("022-inline-nodes.json")
    assert_rendered_result(json_data)
  end

  test "023-hard-breaks" do
    json_data = read_json_file("023-hard-breaks.json")
    assert_rendered_result(json_data)
  end
  #
  # test "024-inline-images" do
  #   json_data = read_json_file("024-inline-images.json")
  #   assert_rendered_result(json_data)
  # end
  #
  # test "025-image-with-hotspot" do
  #   json_data = read_json_file("025-image-with-hotspot.json")
  #   assert_rendered_result(json_data)
  # end
  #
  # test "026-inline-block-with-text" do
  #   json_data = read_json_file("026-inline-block-with-text.json")
  #   assert_rendered_result(json_data)
  # end
  #
  test "027-styled-list-items" do
    json_data = read_json_file("027-styled-list-items.json")
    assert_rendered_result(json_data)
  end
  #
  # test "050-custom-block-type" do
  #   json_data = read_json_file("050-custom-block-type.json")
  #   assert_rendered_result(json_data)
  # end
  #
  # test "051-override-defaults" do
  #   json_data = read_json_file("051-override-defaults.json")
  #   assert_rendered_result(json_data)
  # end
  #
  # test "052-custom-marks" do
  #   json_data = read_json_file("052-custom-marks.json")
  #   assert_rendered_result(json_data)
  # end
  #
  # test "053-override-default-marks" do
  #   json_data = read_json_file("053-override-default-marks.json")
  #   assert_rendered_result(json_data)
  # end
  #
  test "060-list-issue" do
    skip # Not sure what this test is... No expectation.
    json_data = read_json_file("060-list-issue.json")
    assert_rendered_result(json_data)
  end
  #
  # test "061-missing-mark-serializer" do
  #   json_data = read_json_file("061-missing-mark-serializer.json")
  #   assert_rendered_result(json_data)
  # end

  private

    def read_json_file(filename)
      JSON.parse(File.read(File.join(__dir__, "upstream", filename)))
    end

    def assert_rendered_result(json_data)
      input = json_data["input"]
      expected = json_data["output"]

      rendered = @renderer.render(input)

      assert_equal expected, rendered
    end
end