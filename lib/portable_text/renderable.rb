module PortableText
  module Renderable
    def to_html(serializer_registry)
      raise NotImplementedError, "#{self.class} must implement #to_html"
    end
  end
end