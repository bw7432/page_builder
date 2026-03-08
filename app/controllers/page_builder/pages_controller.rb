module PageBuilder
  class PagesController < ApplicationController
    before_action :set_page, only: %i[show edit update destroy]
    before_action :require_admin!, except: %i[index show]
    before_action :protect_drafts, only: :show

    def index
      @pages = if page_builder_admin?
        Page.desc
      else
        Page.active.desc
      end
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
        redirect_to edit_page_path(@page), notice: "Page was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @page.update(page_params)
        redirect_to edit_page_path(@page), notice: "Page was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @page.destroy
      redirect_to pages_path, notice: "Page was successfully destroyed."
    end

    private

    def protect_drafts
      require_admin! unless @page.active?
    end

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
        :featured
      )
    end
  end
end
