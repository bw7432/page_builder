module PageBuilder
  class ApplicationController < ActionController::Base
    helper_method :page_builder_admin?

    private

    def page_builder_admin?
      return true unless respond_to?(:current_user, true)

      user = current_user
      return false unless user
      return user.is_admin? if user.respond_to?(:is_admin?)
      return user.admin? if user.respond_to?(:admin?)

      false
    end

    def require_admin!
      return if page_builder_admin?

      respond_to do |format|
        format.html { redirect_to pages_path, alert: "Not authorized." }
        format.any { head :forbidden }
      end
    end

    def render_not_found
      respond_to do |format|
        format.html { head :not_found }
        format.any { head :not_found }
      end
    end
  end
end
