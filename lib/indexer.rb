require 'sidekiq'
require 'resque'

require "indexer/engine"
require "indexer/manager"
require "indexer/executor_worker"

module Indexer
end
