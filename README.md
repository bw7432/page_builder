# PageBuilder

PageBuilder is an isolated Rails engine for building and rendering marketing or landing pages from structured content. It provides a small CMS-style admin flow for three nested content types:

- `PageBuilder::Page`
- `PageBuilder::Section`
- `PageBuilder::Row`

The engine stores page metadata, rich text, images, nested sections, and repeatable row content, then renders public pages by slug.

## What It Does

The engine supports two main use cases:

- Admin CRUD for pages, sections, and rows.
- Public rendering of active pages through a slug route.

At a high level, content is organized like this:

1. A `Page` is the top-level document.
2. A `Page` has many `Section` records.
3. A `Section` can have child sections and many `Row` records.
4. The page show view renders the page hero content first, then walks the active top-level sections in ascending order.

## Architecture

The engine is isolated with `isolate_namespace PageBuilder`, so its routes, controllers, models, and helpers live under the `PageBuilder` namespace.

Main entry points:

- Engine: [lib/page_builder/engine.rb](/Users/ben/Documents/sites/page_builder/lib/page_builder/engine.rb)
- Routes: [config/routes.rb](/Users/ben/Documents/sites/page_builder/config/routes.rb)
- Base controller: [app/controllers/page_builder/application_controller.rb](/Users/ben/Documents/sites/page_builder/app/controllers/page_builder/application_controller.rb)

The views in [app/views/page_builder](/Users/ben/Documents/sites/page_builder/app/views/page_builder) are written in Slim.

## Installation

Add the gem to the host application:

```ruby
gem "page_builder"
```

Then install dependencies:

```bash
bundle install
```

Mount the engine in the host app routes:

```ruby
mount PageBuilder::Engine => "/page_builder"
```

With the default engine routes, the public page route stays outside the admin area and the CRUD routes live under `/admin` inside the mount:

- public page: `/page_builder/:page_slug`
- admin pages: `/page_builder/admin/pages`
- admin sections: `/page_builder/admin/sections`
- admin rows: `/page_builder/admin/rows`

If you want the whole engine, including public pages, under a host-level admin namespace, you can still mount it there:

```ruby
namespace :admin do
	mount PageBuilder::Engine => "/page_builder", as: :page_builder
end
```

Then configure the engine to use the host app's admin rule instead of guessing at user predicates:

```ruby
# config/initializers/page_builder.rb
PageBuilder.configure do |config|
	config.admin_authorizer = ->(controller) do
		controller.user_signed_in? && controller.current_user&.is_admin
	end

	config.unauthorized_redirect = ->(controller) do
		controller.main_app.root_path
	end
end
```

Without this, the engine falls back to checking `current_user.is_admin`, `current_user.is_admin?`, or `current_user.admin?` when `current_user` is available.

Copy and run the engine migrations in the host app:

```bash
bin/rails page_builder:install:migrations
bin/rails db:migrate
```

## Rails Features Required

PageBuilder depends on Rails features from the host application:

- Active Record
- Action Text
- Active Storage

The models use `has_rich_text` and `has_one_attached`, so the host app must already have Action Text and Active Storage installed and migrated.

If they are not installed yet, run the standard Rails installers in the host application before using this engine:

```bash
bin/rails action_text:install
bin/rails active_storage:install
bin/rails db:migrate
```

## Routes

The engine defines these routes:

- `root` -> redirect to `/admin/pages` inside the engine mount
- `scope "/admin"` -> `pages`, `sections`, and `rows` CRUD
- `get "/:page_slug"` -> `public_pages#show`

That gives you two different kinds of page access:

- Admin-style CRUD paths such as `/page_builder/admin/pages/1/edit`
- Public slug paths such as `/page_builder/my-page-slug`

## Data Model

### Page

Defined in [app/models/page_builder/page.rb](/Users/ben/Documents/sites/page_builder/app/models/page_builder/page.rb).

Responsibilities:

- Stores page metadata and hero content.
- Owns the main page image.
- Owns top-level and nested content through sections.
- Normalizes `slug` before validation.

Associations:

- `has_many :sections`
- `has_many :page_slugs`
- `has_rich_text :body`
- `has_one_attached :image`

Enums:

- `status`: `draft`, `active`, `unpublished`
- `featured`: `unfeatured`, `use_cases`, `homepage`
- `image_type`: `banner`, `portrait`

Important fields:

- `slug`
- `meta_title`
- `meta_keywords`
- `meta_description`
- `h1`
- `background_color`
- `header_text_color`
- `body_text_color`
- `cta`
- `image_styles`

### Section

Defined in [app/models/page_builder/section.rb](/Users/ben/Documents/sites/page_builder/app/models/page_builder/section.rb).

Responsibilities:

- Represents a renderable block inside a page.
- Supports nested sections through a self-reference.
- Can render in several different layouts based on `type_of`.

Associations:

- `belongs_to :page`
- `belongs_to :parent`, optional
- `has_many :sections`
- `has_many :rows`
- `has_rich_text :body`
- `has_one_attached :image`

Enums:

- `header_type`: `hidden`, `h1`, `h2`, `h3`, `h4`
- `type_of`: `text`, `text_image`, `split_pane`, `image_slider`, `cards`, `image_and_rows`, `raw_html`
- `status`: `draft`, `active`, `unpublished`
- `alignment`: `left`, `right`

Important fields:

- `header`
- `header_classes`
- `order`
- `background_color`
- `cta`
- `leading_cols`
- `raw_html`
- `image_styles`

### Row

Defined in [app/models/page_builder/row.rb](/Users/ben/Documents/sites/page_builder/app/models/page_builder/row.rb).

Responsibilities:

- Represents repeated content nested under a section.
- Supports cards, testimonial blocks, image/text combinations, slider items, and inline image/header/body blocks.

Associations:

- `belongs_to :section`
- `has_rich_text :body`
- `has_one_attached :image`

Enums:

- `type_of`: `image_text`, `testimonial`, `image_slider`, `inline_image_header_body`, `card`
- `status`: `draft`, `active`, `unpublished`
- `image_position`: `left`, `top`

Important fields:

- `header`
- `subheader`
- `row_classes`
- `header_classes`
- `inline_styles`
- `url`
- `url_text`
- `url_classes`
- `num_value`

### PageSlug

Defined in [app/models/page_builder/page_slug.rb](/Users/ben/Documents/sites/page_builder/app/models/page_builder/page_slug.rb).

This currently acts as a supporting model for page slug history, although the public controller currently resolves pages directly from `Page.slug`.

## Render Pipeline

The main public render path is in [app/controllers/page_builder/public_pages_controller.rb](/Users/ben/Documents/sites/page_builder/app/controllers/page_builder/public_pages_controller.rb) and [app/views/page_builder/pages/_page.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/pages/_page.html.slim).

The flow is:

1. `PublicPagesController#show` finds the page by `page_slug`.
2. Missing pages return `404`.
3. Draft or unpublished pages are blocked for non-admin users.
4. Admin CRUD remains in the namespaced `/admin` routes handled by `PagesController`, `SectionsController`, and `RowsController`.
5. The page hero block is rendered using the page's `banner` or `portrait` `image_type`.
6. The page then renders all active parent sections in `order ASC`.
7. Each section partial chooses a layout based on `section.type_of`.
8. Sections can recursively render child sections.
9. Row partials render inside section layouts where needed.

## Host App Integration

For a host app such as `turnboards_api`, the usual setup is:

```ruby
# Gemfile
gem "page_builder", path: "../page_builder"
```

```ruby
# config/routes.rb
mount PageBuilder::Engine => "/page_builder"
```

```ruby
# config/initializers/page_builder.rb
PageBuilder.configure do |config|
	config.admin_authorizer = ->(controller) do
		controller.user_signed_in? && controller.current_user&.is_admin
	end

	config.unauthorized_redirect = ->(controller) do
		controller.main_app.root_path
	end
end
```

If you are consuming a published version of the engine instead of the local checkout, swap the `path:` source back to your Git or gem source after the latest engine changes are available there.

Important section partials:

- [app/views/page_builder/sections/_text.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/sections/_text.html.slim)
- [app/views/page_builder/sections/_text_image.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/sections/_text_image.html.slim)
- [app/views/page_builder/sections/_split_pane.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/sections/_split_pane.html.slim)
- [app/views/page_builder/sections/_image_slider.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/sections/_image_slider.html.slim)
- [app/views/page_builder/sections/_cards.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/sections/_cards.html.slim)
- [app/views/page_builder/sections/_image_and_rows.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/sections/_image_and_rows.html.slim)
- [app/views/page_builder/sections/_raw_html.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/sections/_raw_html.html.slim)

Important row partials:

- [app/views/page_builder/rows/_image_text.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/rows/_image_text.html.slim)
- [app/views/page_builder/rows/_testimonial.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/rows/_testimonial.html.slim)
- [app/views/page_builder/rows/_image_slider_item.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/rows/_image_slider_item.html.slim)
- [app/views/page_builder/rows/_inline_image_header_body.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/rows/_inline_image_header_body.html.slim)
- [app/views/page_builder/rows/_card.html.slim](/Users/ben/Documents/sites/page_builder/app/views/page_builder/rows/_card.html.slim)

## Authorization Model

Authorization is intentionally lightweight and lives in [app/controllers/page_builder/application_controller.rb](/Users/ben/Documents/sites/page_builder/app/controllers/page_builder/application_controller.rb).

Behavior:

- If the host app does not define `current_user`, the engine treats requests as admin-capable.
- If `current_user` exists, the engine checks `is_admin?` first, then `admin?`.
- Create, update, and delete actions for pages and sections require admin access.
- Page rendering is public only for active pages.

This means the engine can work in two modes:

- Standalone or internal mode with no host auth integration.
- Host-integrated mode where `current_user` and an admin predicate are available.

## CRUD Screens

The engine includes simple admin UIs for managing content:

- Pages index/edit/new/show
- Sections index/edit/new/show
- Rows index/edit/new/show

The forms use `form_with`, Action Text editors, and Active Storage file fields. These screens are intended to manage content structure, not to provide a full CMS permissions system.

## Styling

The engine layout loads three stylesheets:

- [app/assets/stylesheets/page_builder/application.css](/Users/ben/Documents/sites/page_builder/app/assets/stylesheets/page_builder/application.css)
- [app/assets/stylesheets/page_builder/pages.css](/Users/ben/Documents/sites/page_builder/app/assets/stylesheets/page_builder/pages.css)
- [app/assets/stylesheets/page_builder/sections.css](/Users/ben/Documents/sites/page_builder/app/assets/stylesheets/page_builder/sections.css)

These provide:

- Basic admin layout styling
- Page hero layout styles
- Section and row presentation styles

## Database Migrations

The engine currently ships four consolidated migrations:

- [db/migrate/20260308090001_create_page_builder_pages.rb](/Users/ben/Documents/sites/page_builder/db/migrate/20260308090001_create_page_builder_pages.rb)
- [db/migrate/20260308090002_create_page_builder_page_slugs.rb](/Users/ben/Documents/sites/page_builder/db/migrate/20260308090002_create_page_builder_page_slugs.rb)
- [db/migrate/20260308090003_create_page_builder_sections.rb](/Users/ben/Documents/sites/page_builder/db/migrate/20260308090003_create_page_builder_sections.rb)
- [db/migrate/20260308090004_create_page_builder_rows.rb](/Users/ben/Documents/sites/page_builder/db/migrate/20260308090004_create_page_builder_rows.rb)

The schema is intentionally compact: one migration per engine model.

## Typical Content Setup

To build a page:

1. Create a page and assign a slug.
2. Choose whether the hero image layout is `banner` or `portrait`.
3. Add one or more sections to the page.
4. Choose each section `type_of` based on the presentation you want.
5. Add rows to sections that require repeated nested content.
6. Mark the page and relevant sections as `active` when ready to publish.

## Development Notes

Useful commands while working on the engine:

```bash
bundle install
bundle exec rails test
```

If you update engine migrations and want to test them through the dummy app, run:

```bash
bin/rails db:migrate RAILS_ENV=test
bundle exec rails test
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
