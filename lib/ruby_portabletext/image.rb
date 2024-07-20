class Image
  CDN_BASE_URL = "https://cdn.sanity.io/images"

  attr_reader :key, :project_id, :dataset, :ref, :url, :render_figure, :crop, :hotspot

  def initialize(json, project_id, dataset, render_figure: true)
    @key = json['_key']
    @ref = json['asset']["_ref"]
    @url = json['asset']["url"]
    @crop = json["crop"]
    @hotspot = json["hotspot"]
    @project_id = project_id
    @dataset = dataset
    @render_figure = render_figure
  end

  def to_html
    output_html = ""
    output_html += "<figure>" if render_figure
    output_html += "<img src=\"#{image_url}\"/>"
    output_html += "</figure>" if render_figure
    output_html
  end

  private

    def image_url
      return url if url

      "#{CDN_BASE_URL}/#{project_id}/#{dataset}/#{image_parts[0]}-#{image_parts[1]}.#{image_parts[2]}"
    end

    def image_parts
      @image_parts ||= ref.split("-").drop(1)
    end
end