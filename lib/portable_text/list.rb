require_relative 'renderable'

module PortableText
    class List
      include Renderable

      def initialize(blocks)
        @blocks = blocks
      end
    end
end