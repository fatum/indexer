class IndexerExecutorWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, unique: true

  def perform(indexer, id)
    indexer.constantize.run(id)
    Metric.local_hit :indexer_processed
  rescue Exception => e
    puts e.message
    Metric.local_hit :indexer_failed
  end

  def self.perform(args)
    indexer, id = args

    new.perform(indexer, id)
  end
end