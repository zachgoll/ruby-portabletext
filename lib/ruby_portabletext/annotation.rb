require_relative "mark"

class Annotation < Mark
  attr_reader :attributes

  def initialize(key, json_attributes)
    super(key)
    @attributes = json_attributes
  end

  def open
    raise NotImplementedError
  end

  def close
    raise NotImplementedError
  end

  def sort_score
    0
  end
end