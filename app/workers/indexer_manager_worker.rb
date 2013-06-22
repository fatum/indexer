class IndexerManagerWorker
  include Sidekiq::Worker

  def perform
    Indexer::Manager.new.run!
  end
end