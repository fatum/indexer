module Indexer
  class ExecutorWorker
    include Sidekiq::Worker

    sidekiq_options retry: false, unique: true

    class_attribute :processed, :failed

    def perform(indexer, id)
      indexer.constantize.run(id)
      self.processed.call(indexer, id) if self.processed.respond_to?(:call)
    rescue Exception => e
      self.failed.call(indexer, id, e) if self.failed.respond_to?(:call)
    end

    def self.perform(args)
      indexer, id = args
      new.perform(indexer, id)
    end
  end
end