module PageBuilder
  class PageSlug < ApplicationRecord
    belongs_to :page, class_name: "PageBuilder::Page", inverse_of: :page_slugs
  end
end
