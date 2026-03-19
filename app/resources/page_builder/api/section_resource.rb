require "alba"

module PageBuilder
  module Api
    class SectionResource
      include ::Alba::Resource

      attributes :id,
        :page_id,
        :section_id,
        :header,
        :header_classes,
        :header_type,
        :order,
        :status,
        :background_color,
        :type_of,
        :cta,
        :cta_1_text,
        :cta_1_url,
        :cta_1_type,
        :cta_2_text,
        :cta_2_url,
        :cta_2_type,
        :image_alt,
        :header_text_color,
        :body_text_color,
        :image_width,
        :image_height,
        :image_styles,
        :animate,
        :leading_cols,
        :alignment,
        :raw_html,
        :created_at,
        :updated_at

      attribute :body do |section|
        section.body.to_s
      end

      attribute :image_url do |section|
        section.image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(section.image, only_path: true) : nil
      end

      many :rows, resource: RowResource do |section|
        section.rows.active.order(order: :asc)
      end

      many :sections, resource: SectionResource do |section|
        section.sections.active.ascending
      end
    end
  end
end
