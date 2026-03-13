module PageBuilder
  class PagesController < ApplicationController
    before_action :set_page, only: %i[show edit update destroy]
    before_action :require_admin!

    def index
      @pages = Page.desc
    end

    def show
      @sections = @page.sections.includes(:rich_text_body, :image_attachment, rows: %i[rich_text_body image_attachment]).order(order: :asc)
    end

    def new
      @page = Page.new
    end

    def edit
    end

    def create
      @page = Page.new(page_params)

      if @page.save
        redirect_to edit_admin_page_path(@page), notice: "Page was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @page.update(page_params)
        redirect_to edit_admin_page_path(@page), notice: "Page was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @page.destroy
      redirect_to admin_pages_path, notice: "Page was successfully destroyed."
    end

    private

    def set_page
      @page = Page.find_by(id: params[:id]) || Page.find_by(slug: params[:page_slug])
      render_not_found unless @page
    end

    def page_params
      params.require(:page).permit(
        :image,
        :slug,
        :meta_title,
        :meta_keywords,
        :h1,
        :meta_description,
        :body,
        :status,
        :image_type,
        :background_color,
        :cta,
        :image_alt,
        :header_text_color,
        :body_text_color,
        :image_width,
        :image_height,
        :image_styles,
        :featured,
        :cta_1_text,
        :cta_1_url,
        :cta_1_type,
        :cta_2_text,
        :cta_2_url,
        :cta_2_type
      )
    end
  end
end
