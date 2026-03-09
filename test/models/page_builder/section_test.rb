require "test_helper"

module PageBuilder
  class SectionTest < ActiveSupport::TestCase
    setup do
      @page = Page.create!(slug: "section-page", h1: "Sections", status: :active)
    end

    test "parents scope excludes child sections" do
      parent = Section.create!(page: @page, header: "Parent", status: :active, order: 2)
      Section.create!(page: @page, parent: parent, header: "Child", status: :active, order: 1)

      assert_equal [parent], Section.parents.to_a
    end

    test "ascending scope orders sections by order" do
      later = Section.create!(page: @page, header: "Later", status: :active, order: 2)
      earlier = Section.create!(page: @page, header: "Earlier", status: :active, order: 1)

      assert_equal [earlier, later], Section.ascending.to_a
    end

    test "active scope only returns active sections" do
      active_section = Section.create!(page: @page, header: "Active", status: :active, order: 1)
      Section.create!(page: @page, header: "Draft", status: :draft, order: 2)

      assert_equal [active_section], Section.active.to_a
    end
  end
end
