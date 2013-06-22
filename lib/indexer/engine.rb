module Indexer
  class Engine < ::Rails::Engine
    isolate_namespace Indexer

    config.autoload_paths += %W(#{root}/app/workers)
  end
end
