# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bing/content/api/version'

Gem::Specification.new do |spec|
  spec.name          = "bing-content-api"
  spec.version       = Bing::Content::Api::VERSION
  spec.authors       = ["Paul David"]
  spec.email         = ["paul.david@redbubble.com"]

  spec.summary       = %q{Interface with Bing Content API for managing Shopping Ads.}
  spec.homepage      = "https://github.com/redbubble/bing-content-api"
  spec.license       = "WTFPL"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 3.0.3"
  spec.add_development_dependency "factory_girl", "~> 4.0"

  spec.add_dependency "oauth2", "~> 1.3.1"
end
