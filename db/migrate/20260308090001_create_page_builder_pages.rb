class CreatePageBuilderPages < ActiveRecord::Migration[8.1]
  def change
    create_table :page_builder_pages do |t|
      t.string :slug
      t.string :meta_title
      t.string :meta_keywords
      t.string :h1
      t.string :meta_description
      t.integer :status
      t.string :cta_1_text
      t.string :cta_1_url
      t.integer :cta_1_type, default: 0, null: false
      t.string :cta_2_text
      t.string :cta_2_url
      t.integer :cta_2_type, default: 0, null: false
      t.integer :image_type, default: 0, null: false
      t.string :background_color
      t.boolean :cta, default: false, null: false
      t.string :image_alt
      t.string :header_text_color
      t.string :body_text_color
      t.integer :image_width
      t.integer :image_height
      t.string :image_styles
      t.integer :featured, default: 0, null: false

      t.timestamps
    end

    add_index :page_builder_pages, :slug
  end
end
