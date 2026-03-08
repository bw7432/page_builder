# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_08_090004) do
  create_table "page_builder_page_slugs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "page_id", null: false
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_builder_page_slugs_on_page_id"
    t.index ["slug"], name: "index_page_builder_page_slugs_on_slug"
  end

  create_table "page_builder_pages", force: :cascade do |t|
    t.string "background_color"
    t.string "body_text_color"
    t.datetime "created_at", null: false
    t.boolean "cta", default: false, null: false
    t.integer "featured", default: 0, null: false
    t.string "h1"
    t.string "header_text_color"
    t.string "image_alt"
    t.integer "image_height"
    t.string "image_styles"
    t.integer "image_type", default: 0, null: false
    t.integer "image_width"
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "meta_title"
    t.string "slug"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_page_builder_pages_on_slug"
  end

  create_table "page_builder_rows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "header"
    t.string "header_classes"
    t.integer "image_position", default: 0, null: false
    t.string "image_styles"
    t.string "inline_styles"
    t.decimal "num_value", precision: 4, scale: 2
    t.integer "order"
    t.string "row_classes"
    t.integer "section_id", null: false
    t.integer "status"
    t.string "subheading"
    t.integer "type_of"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "url_classes"
    t.string "url_text"
    t.index ["section_id"], name: "index_page_builder_rows_on_section_id"
  end

  create_table "page_builder_sections", force: :cascade do |t|
    t.integer "alignment", default: 0, null: false
    t.boolean "animate"
    t.string "background_color"
    t.string "body_text_color"
    t.datetime "created_at", null: false
    t.boolean "cta", default: false, null: false
    t.string "header"
    t.string "header_classes"
    t.string "header_text_color"
    t.integer "header_type", default: 2, null: false
    t.string "image_alt"
    t.integer "image_height"
    t.string "image_styles"
    t.integer "image_width"
    t.integer "leading_cols", default: 12, null: false
    t.integer "order"
    t.integer "page_id", null: false
    t.text "raw_html"
    t.integer "section_id"
    t.integer "status"
    t.integer "type_of", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_builder_sections_on_page_id"
    t.index ["section_id"], name: "index_page_builder_sections_on_section_id"
  end

  add_foreign_key "page_builder_page_slugs", "page_builder_pages", column: "page_id"
  add_foreign_key "page_builder_rows", "page_builder_sections", column: "section_id"
  add_foreign_key "page_builder_sections", "page_builder_pages", column: "page_id"
  add_foreign_key "page_builder_sections", "page_builder_sections", column: "section_id"
end
