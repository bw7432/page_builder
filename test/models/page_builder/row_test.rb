require "test_helper"

module PageBuilder
  class RowTest < ActiveSupport::TestCase
    setup do
      page = Page.create!(slug: "row-page", h1: "Rows", status: :active)
      @section = Section.create!(page: page, header: "Section", status: :active, order: 1)
    end

    test "persists the subheader attribute" do
      row = Row.create!(
        section: @section,
        header: "Feature",
        subheader: "Supporting copy",
        status: :active,
        type_of: :image_slider
      )

      assert_equal "Supporting copy", row.reload.subheader
    end

    test "image position defaults to left" do
      row = Row.create!(
        section: @section,
        header: "Feature",
        status: :active,
        type_of: :image_slider
      )

      assert_equal "left", row.image_position
    end
  end
end
