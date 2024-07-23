module PortableText
  module Serializer
    class Registry
      def initialize(serializers = {})
        @serializers = default_serializers.merge(serializers)
      end

      def get(key)
        @serializers[key]
      end

      private

        def default_serializers
          {
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
            underline: Serializer::Underline.new
          }
        end
    end
  end
end