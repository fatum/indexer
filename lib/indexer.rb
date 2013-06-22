require 'sidekiq'
require 'resque'

require "indexer/engine"
require "indexer/manager"
require "indexer/manager_worker"
require "indexer/executor_worker"

module Indexer
end
