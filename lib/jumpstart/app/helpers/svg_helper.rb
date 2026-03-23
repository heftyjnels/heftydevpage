module SvgHelper
  def render_svg(name, options = {})
    if (asset_path = Rails.application.assets.load_path.find("#{name}.svg"))
      document = File.open(asset_path.path) { Nokogiri::XML(it) }

      svg = document.at_css("svg")
      svg.search("title").each { it.remove }
      svg.prepend_child(document.create_element("title", name.underscore.humanize))

      svg["role"] = "img"
      merged_class = safe_join((svg["class"] || "").split(" ") + Array.wrap(options.fetch(:class, "fill-current")), " ")
      svg["class"] = merged_class

      # Allow Tailwind h-/w-/size-* to control dimensions; huge intrinsic width/height (e.g. banner SVGs) otherwise blows flex layouts.
      token_sized = merged_class.split.any? { |c| c.match?(/\A(h-\d+|h-\[|w-\d+|w-\[|size-\d+)/) }
      svg.remove_attribute("width") if token_sized
      svg.remove_attribute("height") if token_sized

      document.to_s.html_safe
    else
      raise NameError, "Unable to find SVG asset named: #{name}.svg"
    end
  end
end
