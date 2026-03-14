class CreatePageBuilderPageSlugs < ActiveRecord::Migration[7.1]
  def change
    create_table :page_builder_page_slugs do |t|
      t.references :page, null: false, foreign_key: { to_table: :page_builder_pages }
      t.string :slug

      t.timestamps
    end

    add_index :page_builder_page_slugs, :slug
  end
end
