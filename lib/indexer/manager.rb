module Indexer
  class Manager
    # use Indexer::Manager.indexers = {} in config/initializers/indexers.rb
    class_attribute :indexers, :model

    def self.run!
      indexers.to_hash.each do |name, attributes|

        can_run_tasks = count_tasks_for_run(name, attributes[:limit])

        next unless can_run_tasks > 0

        # Method fetch_for_indexing must return ids array
        latest_value = get_latest_value(name)
        ids = attributes[:indexer].constantize.fetch_for_indexing(latest_value, can_run_tasks)

        if ids.present? && ids.respond_to?(:each)
          ids.take(can_run_tasks).each do |id|
            enqueue(name, attributes[:indexer], id)
          end

          update_latest_value(name, ids)
        elsif attributes[:retry]
          update_latest_value(name, 0)
        end
      end
    end

    private

    def self.count_tasks_for_run(name, limit)
      enqueued = Indexer::ExecutorWorker.size_block.call(name) || 0
      limit - enqueued
    end

    def self.enqueue(queue, indexer, id)
      Indexer::ExecutorWorker.enqueue_block.call(queue, indexer, id)
    end

    def self.update_latest_value(indexer, ids)
      value = if ids == 0
        ids
      else
        ids.last
      end

      model.find_by_name(indexer.to_s).update_attribute(:last_processed_value, value)
    end

    def self.get_latest_value(indexer)
      model.find_by_name(indexer.to_s).last_processed_value
    end
  end
end
