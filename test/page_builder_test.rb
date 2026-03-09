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

  test "it evaluates one-argument config callables with the controller" do
    controller = PageBuilder::ApplicationController.new

    result = controller.send(:evaluate_config_callable, ->(current_controller) { current_controller.class.name })

    assert_equal "PageBuilder::ApplicationController", result
  end

  test "it evaluates zero-argument config callables in controller context" do
    controller = PageBuilder::ApplicationController.new

    result = controller.send(:evaluate_config_callable, -> { self.class.name })

    assert_equal "PageBuilder::ApplicationController", result
  end
end
