require_relative "block_archived"
require_relative "image"
require_relative "list_items"
require_relative "serializers"

module PortableText
  class RendererArchived
    attr_reader :project_id, :dataset

    def initialize(project_id, dataset)
      @project_id = project_id
      @dataset = dataset
    end

    def render(portabletext_json, serializers_config = {})
      serializers = Serializers.new(serializers_config)
      renderables = create_renderables(portabletext_json, serializers)

      result = renderables.map(&:to_html).join
      result = "<div>#{result}</div>" if renderables.length > 1
      result
    end

    private

      def create_renderables(portabletext_json, serializers_config = {})
        is_array = portabletext_json.is_a?(Array)

        blocks_json = is_array ? portabletext_json : [portabletext_json]

        create_items(blocks_json)
      end

      def create_items(items_json)
        items = items_json.map do |item_json|
          case item_json["_type"]
          when "image"
            Image.new(item_json, project_id, dataset)
          when "block"
            BlockArchived.new(item_json, project_id, dataset)
          else
            raise "Unknown portable text type: #{item_json["_type"]}"
          end
        end

        group_items(items)
      end

      def group_items(items)
        all_items = []
        current_list = []

        items.each_with_index do |item, idx|
          next_item = items[idx + 1] if idx + 1 < items.size

          if item.is_a?(BlockArchived) && item.list_item
            current_list << item

            if next_item.nil? || (next_item.is_a?(BlockArchived) && next_item&.list_item.nil?)
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