require "page_builder/version"
require "page_builder/engine"

module PageBuilder
  mattr_accessor :admin_authorizer, default: nil
  mattr_accessor :unauthorized_redirect, default: nil

  def self.configure
    yield self
  end
end
