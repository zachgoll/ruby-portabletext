require "minitest/autorun"
require "minitest/spec"
require "ruby_portabletext"

module Minitest
  class Test
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\s+/, '_')}", &block)
    end
  end
end
