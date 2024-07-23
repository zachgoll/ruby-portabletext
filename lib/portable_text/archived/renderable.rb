class Renderable
  attr_reader :data, :project_id, :dataset

  def initialize(data, project_id, dataset)
    @data = data
    @project_id = project_id
    @dataset = dataset
  end

  def to_html
    raise NotImplementedError, "Subclasses must implement to_html method"
  end
end