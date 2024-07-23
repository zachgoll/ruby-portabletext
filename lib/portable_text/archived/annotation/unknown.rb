require_relative "../annotation"

class Annotation::Unknown < Annotation
  def open
    "<span>"
  end

  def close
    "</span>"
  end
end