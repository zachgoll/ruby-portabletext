require_relative "../annotation"

class Annotation::Link < Annotation
  def href
    attributes["href"]
  end

  def open
    "<a href=\"#{href}\">"
  end

  def close
    "</a>"
  end
end