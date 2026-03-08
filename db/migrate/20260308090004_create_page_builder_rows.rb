class CreatePageBuilderRows < ActiveRecord::Migration[8.1]
  def change
    create_table :page_builder_rows do |t|
      t.string :header
      t.string :subheader
      t.string :header_classes
      t.integer :status
      t.integer :type_of
      t.integer :image_position, default: 0, null: false
      t.string :inline_styles
      t.string :url
      t.string :url_text
      t.string :url_classes
      t.string :image_styles
      t.string :row_classes
      t.integer :order
      t.decimal :num_value, precision: 4, scale: 2
      t.references :section, null: false, foreign_key: { to_table: :page_builder_sections }

      t.timestamps
    end
  end
end
