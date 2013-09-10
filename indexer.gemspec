$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "indexer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "indexer"
  s.version     = Indexer::VERSION
  s.authors     = ["Maxim Filippovich"]
  s.email       = ["fatumka@gmail.com"]
  s.homepage    = "http://twitter.com/mfilippovich"
  s.summary     = "Scalable indexer"
  s.description = "Simple but efficient indexer implementation"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.add_dependency "activesupport", "3.2.13"
end
