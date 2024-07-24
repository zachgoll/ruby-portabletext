module PortableText
  class MarkDef

    class << self
      def from_json(json)
        new key: json["_key"], type: json["_type"], raw_json: json
      end
    end

    attr_reader :key, :type, :raw_json

    def initialize(key:, type:, raw_json:)
      @key = key
      @type = type
      @raw_json = raw_json
    end
  end
end