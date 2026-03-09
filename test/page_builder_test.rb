require "test_helper"

class PageBuilderTest < ActiveSupport::TestCase
  teardown do
    PageBuilder.admin_authorizer = nil
    PageBuilder.unauthorized_redirect = nil
  end

  test "it has a version number" do
    assert PageBuilder::VERSION
  end

  test "it allows host app configuration" do
    authorizer = ->(_controller) { true }
    redirector = ->(controller) { controller.main_app.root_path }

    PageBuilder.configure do |config|
      config.admin_authorizer = authorizer
      config.unauthorized_redirect = redirector
    end

    assert_same authorizer, PageBuilder.admin_authorizer
    assert_same redirector, PageBuilder.unauthorized_redirect
  end
end
