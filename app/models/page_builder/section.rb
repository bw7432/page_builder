module PageBuilder
  class Section < ApplicationRecord
    has_rich_text :body
    has_one_attached :image

    belongs_to :page, class_name: "PageBuilder::Page", inverse_of: :sections
    belongs_to :parent, class_name: "PageBuilder::Section", foreign_key: :section_id, optional: true, inverse_of: :sections

    has_many :sections, class_name: "PageBuilder::Section", foreign_key: :section_id, dependent: :nullify, inverse_of: :parent
    has_many :rows, class_name: "PageBuilder::Row", dependent: :destroy, inverse_of: :section

    scope :active, -> { where(status: statuses[:active]) }
    scope :parents, -> { where(section_id: nil) }
    scope :ascending, -> { order(order: :asc) }

    enum :header_type, {
      hidden: 0,
      h1: 1,
      h2: 2,
      h3: 3,
      h4: 4
    }

    enum :type_of, {
      text: 0,
      text_image: 1,
      split_pane: 2,
      image_slider: 3,
      cards: 4,
      image_and_rows: 5,
      raw_html: 6
    }

    enum :status, {
      draft: 0,
      active: 1,
      unpublished: 2
    }

    enum :alignment, {
      left: 0,
      right: 1
    }
    enum :cta_1_type, {
      app_store: 0,
      google_play: 1,
      primary: 2,
      secondary: 3
    }, prefix: :cta_1

    enum :cta_2_type, {
      app_store: 0,
      google_play: 1,
      primary: 2,
      secondary: 3
    }, prefix: :cta_2
  end
end
