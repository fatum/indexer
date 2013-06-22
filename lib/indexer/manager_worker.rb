module Indexer
  class ManagerWorker
    include Sidekiq::Worker

    def perform
      Indexer::Manager.new.run!
    end
  end
end