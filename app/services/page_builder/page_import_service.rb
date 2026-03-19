require "json"
require "net/http"
require "open-uri"

module PageBuilder
  class PageImportService
    LOCALHOST_HOSTS = %w[localhost 127.0.0.1 ::1].freeze

    Result = Struct.new(:success?, :page, :error, keyword_init: true)

    def initialize(api_url:)
      @api_url = api_url.to_s.strip
    end

    def call
      return Result.new(success?: false, error: "API URL is required.") if api_url.blank?

      payload = fetch_payload
      return payload if payload.is_a?(Result)

      imported_page = nil

      ActiveRecord::Base.transaction do
        imported_page = import_page(payload)
      end

      Result.new(success?: true, page: imported_page)
    rescue JSON::ParserError
      Result.new(success?: false, error: "API response is not valid JSON.")
    rescue StandardError => e
      Result.new(success?: false, error: e.message)
    end

    private

    attr_reader :api_url

    def fetch_payload
      uri = URI.parse(api_url)
      response = Net::HTTP.get_response(uri)

      return Result.new(success?: false, error: "Failed to fetch page from API (#{response.code}).") unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    rescue URI::InvalidURIError
      Result.new(success?: false, error: "API URL is invalid.")
    rescue SocketError, Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout
      Result.new(success?: false, error: "Unable to reach API URL.")
    end

    def import_page(payload)
      page = Page.new(page_attributes(payload))
      page.slug = unique_slug(page.slug)
      page.save!

      attach_image(page, payload["image_url"])

      Array(payload["sections"]).each do |section_payload|
        import_section(page: page, parent_section: nil, payload: section_payload)
      end

      page
    end

    def import_section(page:, parent_section:, payload:)
      section = Section.create!(section_attributes(payload).merge(page: page, parent: parent_section))
      attach_image(section, payload["image_url"])

      Array(payload["rows"]).each do |row_payload|
        row = Row.create!(row_attributes(row_payload).merge(section: section))
        attach_image(row, row_payload["image_url"])
      end

      Array(payload["sections"]).each do |child_payload|
        import_section(page: page, parent_section: section, payload: child_payload)
      end

      section
    end

    def page_attributes(payload)
      {
        slug: payload["slug"],
        meta_title: payload["meta_title"],
        meta_keywords: payload["meta_keywords"],
        meta_description: payload["meta_description"],
        h1: payload["h1"],
        body: payload["body"],
        status: payload["status"],
        featured: payload["featured"],
        image_type: payload["image_type"],
        background_color: payload["background_color"],
        cta: payload["cta"],
        image_alt: payload["image_alt"],
        header_text_color: payload["header_text_color"],
        body_text_color: payload["body_text_color"],
        image_width: payload["image_width"],
        image_height: payload["image_height"],
        image_styles: payload["image_styles"],
        cta_1_text: payload["cta_1_text"],
        cta_1_url: payload["cta_1_url"],
        cta_1_type: payload["cta_1_type"],
        cta_2_text: payload["cta_2_text"],
        cta_2_url: payload["cta_2_url"],
        cta_2_type: payload["cta_2_type"]
      }
    end

    def section_attributes(payload)
      {
        header: payload["header"],
        header_classes: payload["header_classes"],
        header_type: payload["header_type"],
        order: payload["order"],
        body: payload["body"],
        status: payload["status"],
        background_color: payload["background_color"],
        type_of: payload["type_of"],
        cta: payload["cta"],
        cta_1_text: payload["cta_1_text"],
        cta_1_url: payload["cta_1_url"],
        cta_1_type: payload["cta_1_type"],
        cta_2_text: payload["cta_2_text"],
        cta_2_url: payload["cta_2_url"],
        cta_2_type: payload["cta_2_type"],
        image_alt: payload["image_alt"],
        header_text_color: payload["header_text_color"],
        body_text_color: payload["body_text_color"],
        image_width: payload["image_width"],
        image_height: payload["image_height"],
        image_styles: payload["image_styles"],
        animate: payload["animate"],
        leading_cols: payload["leading_cols"],
        alignment: payload["alignment"],
        raw_html: payload["raw_html"]
      }
    end

    def row_attributes(payload)
      {
        header: payload["header"],
        subheader: payload["subheader"],
        header_classes: payload["header_classes"],
        status: payload["status"],
        type_of: payload["type_of"],
        image_position: payload["image_position"],
        inline_styles: payload["inline_styles"],
        cta_1_text: payload["cta_1_text"],
        cta_1_url: payload["cta_1_url"],
        cta_1_type: payload["cta_1_type"],
        cta_2_text: payload["cta_2_text"],
        cta_2_url: payload["cta_2_url"],
        cta_2_type: payload["cta_2_type"],
        url: payload["url"],
        url_text: payload["url_text"],
        url_classes: payload["url_classes"],
        image_styles: payload["image_styles"],
        row_classes: payload["row_classes"],
        order: payload["order"],
        num_value: payload["num_value"],
        body: payload["body"]
      }
    end

    def unique_slug(slug)
      base_slug = slug.to_s.parameterize
      base_slug = "imported-page" if base_slug.blank?

      candidate = base_slug
      counter = 2

      while Page.exists?(slug: candidate)
        candidate = "#{base_slug}-#{counter}"
        counter += 1
      end

      candidate
    end

    def attach_image(record, image_url)
      return if image_url.blank?

      resolved_image_url = resolve_image_url(image_url)
      return if resolved_image_url.blank?

      image_io = URI.open(resolved_image_url)
      filename = File.basename(URI.parse(resolved_image_url).path)
      filename = "image" if filename.blank?

      record.image.attach(io: image_io, filename: filename)
    rescue StandardError => e
      Rails.logger.warn("Page import image attach failed for #{image_url}: #{e.message}")
    end

    def resolve_image_url(image_url)
      image_uri = URI.parse(image_url)
      return image_url if image_uri.absolute?

      localhost_base = localhost_api_base_url
      return nil if localhost_base.blank?

      URI.join(localhost_base, image_url).to_s
    rescue URI::InvalidURIError
      nil
    end

    def localhost_api_base_url
      api_uri = URI.parse(api_url)
      return nil unless LOCALHOST_HOSTS.include?(api_uri.host)

      base_url = "#{api_uri.scheme}://#{api_uri.host}"
      base_url = "#{base_url}:#{api_uri.port}" unless [ 80, 443 ].include?(api_uri.port)
      base_url
    rescue URI::InvalidURIError
      nil
    end
  end
end
