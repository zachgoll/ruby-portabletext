module PortableText
  module Serializer
    class Registry
      def initialize(base_image_url)
        @base_image_url = base_image_url
        @serializers = default_serializers
      end

      def get(key)
        @serializers[key.to_sym]
      end

      def register(key, serializer)
        @serializers[key.to_sym] = serializer
      end

      private

        def default_serializers
          {
            ul: Serializer::HTMLElement.new("ul"),
            ol: Serializer::HTMLElement.new("ol"),
            li: Serializer::ListItem.new,
            normal: Serializer::HTMLElement.new("p"),
            h1: Serializer::HTMLElement.new("h1"),
            h2: Serializer::HTMLElement.new("h2"),
            h3: Serializer::HTMLElement.new("h3"),
            h4: Serializer::HTMLElement.new("h4"),
            h5: Serializer::HTMLElement.new("h5"),
            h6: Serializer::HTMLElement.new("h6"),
            blockquote: Serializer::HTMLElement.new("blockquote"),
            strong: Serializer::HTMLElement.new("strong"),
            em: Serializer::HTMLElement.new("em"),
            code: Serializer::HTMLElement.new("code"),
            "strike-through": Serializer::HTMLElement.new("del"),
            underline: Serializer::Underline.new,
            link: Serializer::Link.new,
            image: Serializer::Image.new(@base_image_url),
            span: Serializer::Span.new,
          }
        end
    end
  end
end