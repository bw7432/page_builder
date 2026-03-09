module PageBuilder
  class ApplicationController < ActionController::Base
    helper_method :page_builder_admin?

    private

    def page_builder_admin?
      if PageBuilder.admin_authorizer.respond_to?(:call)
        return !!PageBuilder.admin_authorizer.call(self)
      end

      return true unless respond_to?(:current_user, true)

      user = current_user
      return false unless user
      return user.is_admin if user.respond_to?(:is_admin)
      return user.is_admin? if user.respond_to?(:is_admin?)
      return user.admin? if user.respond_to?(:admin?)

      false
    end

    def require_admin!
      return if page_builder_admin?

      respond_to do |format|
        format.html { redirect_to unauthorized_redirect_path, alert: "Not authorized." }
        format.any { head :forbidden }
      end
    end

    def unauthorized_redirect_path
      return instance_exec(&PageBuilder.unauthorized_redirect) if PageBuilder.unauthorized_redirect.respond_to?(:call)

      admin_pages_path
    end

    def render_not_found
      respond_to do |format|
        format.html { head :not_found }
        format.any { head :not_found }
      end
    end
  end
end
