module PageBuilder
  class PublicPagesController < ApplicationController
    before_action :set_page

    def show
      render_not_found and return unless @page
      render_not_found and return unless @page.active? || page_builder_admin?

      @sections = @page.sections.includes(:rich_text_body, :image_attachment, rows: %i[rich_text_body image_attachment]).order(order: :asc)

      render "page_builder/pages/show"
    end

    private

    def set_page
      @page = Page.find_by(slug: params[:page_slug])
    end
  end
end
