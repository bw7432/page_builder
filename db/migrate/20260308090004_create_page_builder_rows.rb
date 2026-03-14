class CreatePageBuilderRows < ActiveRecord::Migration[7.1]
  def change
    create_table :page_builder_rows do |t|
      t.string :header
      t.string :subheader
      t.string :header_classes
      t.integer :status
      t.integer :type_of
      t.integer :image_position, default: 0, null: false
      t.string :inline_styles
      t.string :cta_1_text
      t.string :cta_1_url
      t.integer :cta_1_type, default: 0, null: false
      t.string :cta_2_text
      t.string :cta_2_url
      t.integer :cta_2_type, default: 0, null: false
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
