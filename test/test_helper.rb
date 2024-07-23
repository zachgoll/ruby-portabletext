require "minitest/autorun"
require "minitest/spec"
require "json"
require "portable_text"

module Minitest
  class Test
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\s+/, '_')}", &block)
    end

    def read_json_file(filename)
      JSON.parse(File.read(File.join(__dir__, "upstream", filename)))
    end

    def create_block(attributes = {}, serializer = nil)
      serializer = serializer || PortableText::Serializer::HTMLElement.new("p")
      PortableText::Block.new(serializer: serializer, attributes: attributes)
    end

    def create_child(type: "span", attributes: {}, serializer: nil, raw_json: {})
      serializer = serializer || PortableText::Serializer::HTMLElement.new("span")
      if type == "span"
        defaults = { type: "span" }
        PortableText::Span.new(attributes: defaults.merge(attributes))
      else
        PortableText::Block.new(serializer: serializer, attributes: attributes, raw_json: raw_json)
      end
    end
  end
end
