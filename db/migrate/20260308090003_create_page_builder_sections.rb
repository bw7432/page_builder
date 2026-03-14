class CreatePageBuilderSections < ActiveRecord::Migration[7.1]
  def change
    create_table :page_builder_sections do |t|
      t.string :header
      t.string :header_classes
      t.integer :header_type, default: 2, null: false
      t.integer :order
      t.references :page, null: false, foreign_key: { to_table: :page_builder_pages }
      t.integer :status
      t.string :background_color
      t.integer :type_of, default: 0, null: false
      t.boolean :cta, default: false, null: false
      t.string :cta_1_text
      t.string :cta_1_url
      t.integer :cta_1_type, default: 0, null: false
      t.string :cta_2_text
      t.string :cta_2_url
      t.integer :cta_2_type, default: 0, null: false
      t.string :image_alt
      t.string :header_text_color
      t.string :body_text_color
      t.references :section, foreign_key: { to_table: :page_builder_sections }
      t.integer :image_width
      t.integer :image_height
      t.string :image_styles
      t.boolean :animate
      t.integer :leading_cols, default: 12, null: false
      t.integer :alignment, default: 0, null: false
      t.text :raw_html

      t.timestamps
    end
  end
end
