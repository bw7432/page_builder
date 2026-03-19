require "alba"

module PageBuilder
  module Api
    class PageResource
      include ::Alba::Resource

      attributes :id,
        :slug,
        :meta_title,
        :meta_keywords,
        :meta_description,
        :h1,
        :status,
        :featured,
        :image_type,
        :background_color,
        :cta,
        :image_alt,
        :header_text_color,
        :body_text_color,
        :image_width,
        :image_height,
        :image_styles,
        :cta_1_text,
        :cta_1_url,
        :cta_1_type,
        :cta_2_text,
        :cta_2_url,
        :cta_2_type,
        :created_at,
        :updated_at

      attribute :body do |page|
        page.body.to_s
      end

      attribute :image_url do |page|
        page.image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(page.image, only_path: true) : nil
      end

      many :sections, resource: SectionResource do |page|
        page.sections.active.parents.ascending
      end
    end
  end
end
