require "alba"

module PageBuilder
  module Api
    class RowResource
      include ::Alba::Resource

      attributes :id,
        :section_id,
        :header,
        :subheader,
        :header_classes,
        :status,
        :type_of,
        :image_position,
        :inline_styles,
        :cta_1_text,
        :cta_1_url,
        :cta_1_type,
        :cta_2_text,
        :cta_2_url,
        :cta_2_type,
        :url,
        :url_text,
        :url_classes,
        :image_styles,
        :row_classes,
        :order,
        :num_value,
        :created_at,
        :updated_at

      attribute :body do |row|
        row.body.to_s
      end

      attribute :image_url do |row|
        row.image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(row.image, only_path: true) : nil
      end
    end
  end
end
