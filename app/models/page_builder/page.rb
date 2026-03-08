module PageBuilder
  class Page < ApplicationRecord
    has_rich_text :body
    has_one_attached :image

    has_many :sections, class_name: "PageBuilder::Section", dependent: :destroy, inverse_of: :page
    has_many :page_slugs, class_name: "PageBuilder::PageSlug", dependent: :destroy, inverse_of: :page

    before_validation :set_slug

    scope :active, -> { where(status: statuses[:active]) }
    scope :desc, -> { order(created_at: :desc) }
    scope :unfeatured, -> { where(featured: featureds[:unfeatured]) }
    scope :use_cases, -> { where(featured: featureds[:use_cases]) }

    enum :status, {
      draft: 0,
      active: 1,
      unpublished: 2
    }

    enum :featured, {
      unfeatured: 0,
      use_cases: 1,
      homepage: 2
    }

    enum :image_type, {
      banner: 0,
      portrait: 1
    }

    def cta?
      cta
    end

    private

    def set_slug
      self.slug = slug.to_s.parameterize if slug.present?
    end
  end
end
