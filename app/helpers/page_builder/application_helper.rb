module PageBuilder
  module ApplicationHelper
    def normalized_section_image_style(image_styles)
      style = image_styles.to_s.strip

      return if style.blank?
      return style unless style.match?(/(^|;)\s*height\s*:/i)
      return style if style.match?(/(^|;)\s*width\s*:/i)

      [style, "width: auto", "max-width: 100%"].join("; ")
    end
  end
end
