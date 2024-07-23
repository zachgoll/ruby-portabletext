module PortableText
  class Configuration
    attr_accessor :serializers, :project_id, :dataset

    def initialize(project_id: nil, dataset: nil, serializers: {})
      @serializers = serializers
      @project_id = project_id
      @dataset = dataset
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end