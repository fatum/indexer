$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "indexer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "indexer"
  s.version     = Indexer::VERSION
  s.authors     = ["Maxim Filippovich"]
  s.email       = ["fatumka@gmail.com"]
  s.homepage    = "fatumka@gmail.com"
  s.summary     = "Scalable indexer"
  s.description = "Simple but efficient indexer implementation"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
