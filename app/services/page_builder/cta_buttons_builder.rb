module PageBuilder
  class CtaButtonsBuilder
    STORE_TYPES = %w[app_store google_play].freeze
    BUTTON_TYPES = %w[primary secondary].freeze

    def initialize(record)
      @record = record
    end

    def build
      [build_button(1), build_button(2)].compact
    end

    private

    attr_reader :record

    def build_button(index)
      cta_type = record.public_send("cta_#{index}_type")
      cta_url = record.public_send("cta_#{index}_url").to_s.strip
      cta_text = record.public_send("cta_#{index}_text").to_s.strip

      return if cta_type.blank? || cta_url.blank?

      if STORE_TYPES.include?(cta_type)
        return {
          kind: :store,
          url: cta_url,
          image_path: cta_image_path(cta_type),
          alt: cta_alt_text(cta_type)
        }
      end

      return unless BUTTON_TYPES.include?(cta_type)
      return if cta_text.blank?

      {
        kind: :button,
        url: cta_url,
        text: cta_text,
        button_class: "btn btn-#{cta_type}"
      }
    end

    def cta_image_path(cta_type)
      case cta_type
      when "app_store"
        "page_builder/appstore-apple.svg"
      when "google_play"
        "page_builder/appstore-android.svg"
      end
    end

    def cta_alt_text(cta_type)
      case cta_type
      when "app_store"
        "Download on the App Store"
      when "google_play"
        "Get it on Google Play"
      end
    end
  end
end
