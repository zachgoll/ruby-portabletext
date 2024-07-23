module PortableText
  module Renderable
    def to_html(wrapping_html = nil)
      raise NotImplementedError, "#{self.class} must implement #to_html"
    end
  end
end