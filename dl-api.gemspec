require File.expand_path("../lib/dl-api/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name    = 'dl-api'
  spec.version = DL::VERSION
  spec.date    = Date.today.to_s

  spec.summary = "dl-api ruby client"
  spec.description = "dl-api client for ruby"

  spec.authors  = ['Endel Dreyer']
  spec.email    = 'edreyer@doubleleft.com'
  spec.homepage = 'http://github.com/doubleleft/dl-api-ruby'

  spec.add_dependency 'rake'
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'http', '~> 0.6.0'

  spec.add_development_dependency('rspec', [">= 2.0.0"])

  # ensure the gem is built out of versioned files
  spec.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end
