module PageBuilder
  class SectionsController < ApplicationController
    before_action :set_section, only: %i[show edit update destroy]
    before_action :require_admin!

    def index
      @sections = Section.where(page_id: params[:page_id]).includes(:page).order(order: :asc)
    end

    def show
    end

    def new
      @section = Section.new(page_id: params[:page_id])
    end

    def edit
    end

    def create
      @section = Section.new(section_params)

      if @section.save
        redirect_to admin_sections_path(page_id: @section.page_id), notice: "Section was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @section.update(section_params)
        redirect_to admin_sections_path(page_id: @section.page_id), notice: "Section was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      page_id = @section.page_id
      @section.destroy
      redirect_to admin_sections_path(page_id: page_id), notice: "Section was successfully destroyed."
    end

    private

    def set_section
      @section = Section.find(params[:id])
    end

    def section_params
      params.require(:section).permit(
        :image,
        :header,
        :header_classes,
        :header_type,
        :order,
        :page_id,
        :body,
        :status,
        :background_color,
        :type_of,
        :cta,
        :image_alt,
        :header_text_color,
        :body_text_color,
        :section_id,
        :image_width,
        :image_height,
        :image_styles,
        :animate,
        :leading_cols,
        :alignment,
        :raw_html
      )
    end
  end
end
