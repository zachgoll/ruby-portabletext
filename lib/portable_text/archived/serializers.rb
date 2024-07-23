class Serializers
  CATEGORIES = [:types, :marks, :block]

  def initialize(config)
    @config = config
    process_config
  end

  def types
    @processed_config[:types]
  end

  def blocks
    @processed_config[:block]
  end

  def marks
    @processed_config[:marks]
  end

  private

    def process_config
      @processed_config = CATEGORIES.each_with_object({}) do |category, processed|
        processed[category] = process_category(category)
      end
    end

    def process_category(category)
      return {} unless @config[category].is_a?(Hash)

      @config[category].transform_keys(&:to_sym).transform_values do |key, render_proc|
        Serializer.new(category, key, render_proc)
      end
    end

    def default_serializers
      {
        types: {
          block: ->(data) {},
          span: ->(data) {}
        },
        styles: {
          normal: ->(data) {},
          h1: ->(data) {},
          h2: ->(data) {},
          h3: ->(data) {},
          h4: ->(data) {},
          h5: ->(data) {},
          h6: ->(data) {},
          blockquote: ->(data) {}
        },
        marks: {
          strong: ->(data) {},
          em: ->(data) {},
          code: ->(data) {},
          "strike-through": ->(data) {},
          underline: ->(data) {}
        }
      }
    end
end