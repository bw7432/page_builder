module PageBuilder
  class RowsController < ApplicationController
    before_action :set_row, only: %i[show edit update destroy]
    before_action :require_admin!

    def index
      @rows = Row.where(section_id: params[:section_id]).includes(:section).order(order: :asc)
    end

    def show
    end

    def new
      @row = Row.new(section_id: params[:section_id])
    end

    def edit
    end

    def create
      @row = Row.new(row_params)

      if @row.save
        redirect_to admin_rows_path(section_id: @row.section_id), notice: "Row was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @row.update(row_params)
        redirect_to admin_rows_path(section_id: @row.section_id), notice: "Row was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      section_id = @row.section_id
      @row.destroy
      redirect_to admin_rows_path(section_id: section_id), notice: "Row was successfully destroyed."
    end

    private

    def set_row
      @row = Row.find(params[:id])
    end

    def row_params
      params.require(:row).permit(
        :header,
        :subheader,
        :body,
        :status,
        :type_of,
        :inline_styles,
        :section_id,
        :image,
        :url,
        :url_text,
        :url_classes,
        :image_styles,
        :row_classes,
        :image_position,
        :order,
        :num_value,
        :header_classes
      )
    end
  end
end
