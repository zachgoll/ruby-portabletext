module PortableText
  class MarkDef
    attr_reader :type, :raw_json

    def initialize(type, raw_json:)
      @type = type
      @raw_json = raw_json
    end
  end
end