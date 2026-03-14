require_relative "lib/page_builder/version"

Gem::Specification.new do |spec|
  spec.name        = "page_builder"
  spec.version     = PageBuilder::VERSION
  spec.authors     = [ "Ben Warren" ]
  spec.email       = [ "benwade24@gmail.com" ]
  spec.homepage    = "https://github.com/bw7432/page_builder"
  spec.summary     = "Rails engine for building marketing pages"
  spec.description = "Isolated Rails engine for managing and rendering structured marketing and landing pages."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/bw7432/page_builder/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.0", "< 9.0"
  spec.add_dependency "slim-rails"
end
