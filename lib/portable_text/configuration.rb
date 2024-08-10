module PortableText
  class Configuration
    attr_accessor :serializer_registry, :project_id, :dataset, :cdn_base_url, :on_missing_serializer
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)

      configuration.serializer_registry = Serializer::Registry.new \
        base_image_url: base_image_url,
        on_missing_serializer: configuration.on_missing_serializer
    end

    def base_image_url
      [
        configuration.cdn_base_url,
        configuration.project_id,
        configuration.dataset
      ].join("/")
    end
  end
end