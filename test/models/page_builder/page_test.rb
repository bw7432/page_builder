require "test_helper"

module PageBuilder
  class PageTest < ActiveSupport::TestCase
    test "parameterizes slug before validation" do
      page = Page.new(
        slug: "Hello World Page",
        h1: "Hello",
        meta_title: "Meta"
      )

      page.valid?

      assert_equal "hello-world-page", page.slug
    end

    test "active scope only returns active pages" do
      active_page = Page.create!(slug: "active-page", h1: "Active", status: :active)
      Page.create!(slug: "draft-page", h1: "Draft", status: :draft)

      assert_equal [active_page], Page.active.to_a
    end

    test "desc scope orders newest first" do
      older_page = Page.create!(slug: "older-page", h1: "Older", status: :active)
      newer_page = Page.create!(slug: "newer-page", h1: "Newer", status: :active)

      older_page.update_column(:created_at, 2.days.ago)
      newer_page.update_column(:created_at, 1.day.ago)

      assert_equal [newer_page, older_page], Page.desc.to_a
    end
  end
end
