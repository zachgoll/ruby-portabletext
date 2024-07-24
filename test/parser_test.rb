require "test_helper"

class ParserTest < Minitest::Test
  test "can parse single block" do
    json_data = read_json_file("001-empty-block.json")["input"]

    parser = PortableText::Parser.new

    assert_equal 1, parser.parse(json_data).length
  end

  test "can parse array of blocks" do
    json_data = read_json_file("017-all-default-block-styles.json")["input"]

    parser = PortableText::Parser.new

    assert_equal 9, parser.parse(json_data).length
  end

  test "can parse lists" do
    json_data = read_json_file("014-nested-lists.json")["input"]

    assert_equal 13, json_data.length

    parser = PortableText::Parser.new

    # 2 blocks, 2 lists
    assert_equal 4, parser.parse(json_data).length
  end

  test "raises on invalid types" do
    invalid = {
      "style" => "h4",
      "_type" => "unregistered_type",
      "_key" => "06ca981a1d18",
      "markDefs" => [],
      "children" => [
        {
          "_type" => "span",
          "text" => "test",
          "marks" => []
        }
      ]
    }

    assert_raises PortableText::UnknownTypeError do
      PortableText::Parser.new.parse(invalid)
    end
  end
end