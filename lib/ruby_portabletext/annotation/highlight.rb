require_relative "../annotation"

class Annotation::Highlight < Annotation
  def thickness
    attributes["thickness"]
  end

  def open
    "<span style=\"border:#{thickness}px solid;\">"
  end

  def close
    "</span>"
  end
end