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
  end
end
