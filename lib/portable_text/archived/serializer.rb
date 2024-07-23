class Serializer
  attr_reader :category, :key, :render_proc

  def initialize(category, key, render_proc)
    @category = category
    @key = key
    @render_proc = render_proc
  end

  def call(data)
    render_proc.call(data)
  end
end