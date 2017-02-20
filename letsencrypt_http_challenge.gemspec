$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "letsencrypt_http_challenge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "letsencrypt_http_challenge"
  s.version     = LetsencryptHttpChallenge::VERSION
  s.authors     = ["Luc Lussier"]
  s.email       = ["luc.lussier@gmail.com"]
  s.homepage    = "https://github.com/datamolecule/letsencrypt_http_challenge"
  s.summary     = "Answer the Let's Encrypt ACME http challenge"
  s.description = "A Rails engine that provides a response mechanism for Let's Encrypt ACME - Simple HTTP - Identifier Validation Challenges on 12 factor apps like those deployed on Heroku as well as the rake task to generate the certificate from your local machine."
  s.license     = "MIT"

  s.files = Dir["{app,bin,config,lib}/**/*", "Gemfile", "LICENSE", "README.md", "Rakefile", "letsencrypt_http_challenge.gemspec"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "acme-client", "~> 0.3.0"
  s.add_dependency "figaro"

  s.add_development_dependency "byebug"
  s.add_development_dependency "rails", "~> 5.0"
end
