module Indexer
  class ExecutorWorker
    class_attribute :processed_block, :failed_block, :enqueue_block, :size_block

    def self.perform(args)
      indexer, id = args
      indexer.constantize.run(id)
      self.processed_block.call(indexer, id) if self.processed_block.respond_to?(:call)
    rescue Exception => e
      self.failed_block.call(indexer, id, e) if self.failed_block.respond_to?(:call)
    end

    def self.setup(&block)
      class_eval &block
    end

    def self.processed(&block)
      self.processed_block = block
    end

    def self.failed(&block)
      self.failed_block = block
    end

    def self.size(&block)
      self.size_block = block
    end

    def self.enqueue(&block)
      self.enqueue_block = block
    end
  end
end
