module PageBuilder
  class Row < ApplicationRecord
    has_rich_text :body
    has_one_attached :image

    belongs_to :section, class_name: "PageBuilder::Section", inverse_of: :rows

    enum :type_of, {
      image_text: 0,
      testimonial: 1,
      image_slider: 2,
      inline_image_header_body: 3,
      card: 4
    }

    enum :status, {
      draft: 0,
      active: 1,
      unpublished: 2
    }

    enum :image_position, {
      left: 0,
      top: 1
    }
  end
end
