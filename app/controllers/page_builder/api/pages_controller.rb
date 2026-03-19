module PageBuilder
  module Api
    class PagesController < ApplicationController
      before_action :set_page, only: :show
      before_action :require_admin!, only: :import_page

      def show
        render_not_found and return unless @page
        render_not_found and return unless @page.active? || page_builder_admin?

        render body: PageResource.new(@page).serialize, content_type: "application/json"
      end

      def import_page
        result = PageImportService.new(api_url: params[:api_url]).call

        if result.success?
          redirect_to edit_admin_page_path(result.page), notice: "Page imported successfully."
        else
          redirect_to admin_pages_path, alert: result.error
        end
      end

      private

      def set_page
        @page = Page.includes(sections: [ :rich_text_body, :image_attachment, { rows: %i[rich_text_body image_attachment] } ])
          .find_by(slug: params[:page_slug])
      end
    end
  end
end
