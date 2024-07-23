module PortableText
    class Children
      def initialize(elements:, raw_json:)
        @elements = elements
        @raw_json = raw_json
      end

      private
        attr_reader :elements, :raw_json

        def mark_frequencies
          # PH
        end
  end
end