require_relative "block"
require_relative "image"
require_relative "list_items"

module RubyPortabletext
  class Renderer
    attr_reader :project_id, :dataset

    def initialize(project_id, dataset)
      @project_id = project_id
      @dataset = dataset
    end

    def render(portabletext_json)
      output = ""

      is_array = portabletext_json.is_a?(Array)

      if is_array && portabletext_json.length > 1
        output += "<div>"
      end

      blocks_json = is_array ? portabletext_json : [portabletext_json]

      items = create_items(blocks_json)

      items.each do |item|
        output += item.to_html
      end

      if is_array && portabletext_json.length > 1
        output += "</div>"
      end

      output
    end

    private

      def create_items(items_json)
        items = items_json.map do |item_json|
          case item_json["_type"]
          when "image"
            Image.new(item_json, project_id, dataset)
          when "block"
            Block.new(item_json, project_id, dataset)
          else
            raise "Unknown portable text type: #{item_json["_type"]}"
          end
        end

        all_items = []
        current_list = []

        items.each_with_index do |item, idx|
          next_item = items[idx + 1] if idx + 1 < items.size

          if item.is_a?(Block) && item.list_item
            current_list << item

            if next_item.nil? || (next_item.is_a?(Block) && next_item&.list_item.nil?)
              all_items << ListItems.new(current_list)
              current_list = []
            end
          else
            all_items << item
          end
        end

        all_items
      end
  end
end