class CreatePageBuilderPages < ActiveRecord::Migration[8.1]
  def change
    create_table :page_builder_pages do |t|
      t.string :slug
      t.string :meta_title
      t.string :meta_keywords
      t.string :h1
      t.string :meta_description
      t.integer :status
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
