module Indexer
  class Manager
    # use Indexer::Manager.indexers = {} in config/initializers/indexers.rb
    class_attribute :indexers

    def run!
      self.indexers.to_hash.each do |name, attributes|

        can_run_tasks = count_tasks_for_run(name, attributes[:limit], attributes[:resque])

        next unless can_run_tasks > 0

        # Method fetch_for_indexing must return ids array
        latest_value = get_latest_value(name)
        ids = attributes[:indexer].constantize.fetch_for_indexing(latest_value, can_run_tasks)

        if ids.present? && ids.respond_to?(:each)
          ids.take(can_run_tasks).each do |id|
            enqueue(name, attributes[:indexer], id, attributes[:resque])
          end

          update_latest_value(name, ids)
        elsif attributes[:retry]
          update_latest_value(name, 0)
        end
      end
    end

    private

    def count_tasks_for_run(name, limit, resque)
      enqueued = if resque
        Resque.size(name) || 0
      else
        Sidekiq::Queue.new(name).size
      end

      limit - enqueued
    end

    def enqueue(queue, indexer, id, resque)
      if resque
        Resque::Job.create(
            queue, Indexer::ExecutorWorker, [indexer, id]
          )
      else
        Sidekiq::Client.push('queue' => queue, 'class' => Indexer::ExecutorWorker, 'args' => [indexer, id])
      end
    end

    def update_latest_value(indexer, ids)
      value = if ids == 0
        ids
      else
        ids.last
      end

      Indexer::Status.find_by_name(indexer.to_s).update_attribute(:last_processed_value, value)
    end

    def get_latest_value(indexer)
      Indexer::Status.find_by_name(indexer.to_s).last_processed_value
    end
  end
end