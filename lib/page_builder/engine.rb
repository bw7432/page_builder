module PageBuilder
  class Engine < ::Rails::Engine
    isolate_namespace PageBuilder

    initializer "page_builder.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper PageBuilder::ApplicationHelper
      end
    end

    initializer "page_builder.assets.precompile" do |app|
      app.config.assets.precompile += %w[
        page_builder/application.css
        page_builder/pages.css
        page_builder/sections.css
        page_builder/appstore-apple.svg
        page_builder/appstore-android.svg
      ]
    end
  end
end
