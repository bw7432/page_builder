require "test_helper"

class PageBuilderRoutingTest < ActionDispatch::IntegrationTest
  test "routes pages index" do
    assert_recognizes(
      { controller: "page_builder/pages", action: "index" },
      { method: "get", path: "/page_builder/pages" }
    )
  end

  test "routes page show by slug" do
    assert_recognizes(
      { controller: "page_builder/pages", action: "show", page_slug: "sample-page" },
      { method: "get", path: "/page_builder/sample-page" }
    )
  end

  test "routes rows create" do
    assert_recognizes(
      { controller: "page_builder/rows", action: "create" },
      { method: "post", path: "/page_builder/rows" }
    )
  end

  test "routes rows update" do
    assert_recognizes(
      { controller: "page_builder/rows", action: "update", id: "12" },
      { method: "patch", path: "/page_builder/rows/12" }
    )
  end

  test "routes sections index" do
    assert_recognizes(
      { controller: "page_builder/sections", action: "index" },
      { method: "get", path: "/page_builder/sections" }
    )
  end
end
