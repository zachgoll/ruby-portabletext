class MarkDef
  attr_reader :key, :type, :attributes

  def initialize(json)
    @key = json["_key"]
    @type = json["_type"]
    @attributes = json.except("_type", "_key")
  end
end