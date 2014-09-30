require File.expand_path("../lib/hook-client/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name    = 'hook-client'
  spec.version = Hook::VERSION
  spec.date    = Date.today.to_s

  spec.summary = "Hook Ruby Client"
  spec.description = "Hook Client for Ruby"

  spec.authors  = ['Endel Dreyer']
  spec.email    = 'endel@doubleleft.com'
  spec.homepage = 'http://github.com/doubleleft/hook-ruby'

  spec.add_dependency 'rake'
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'http', '~> 0.6.0'

  spec.add_development_dependency('rspec', [">= 2.0.0"])
  spec.add_development_dependency('activemodel', [">= 3.0.0"])

  # ensure the gem is built out of versioned files
  spec.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end
