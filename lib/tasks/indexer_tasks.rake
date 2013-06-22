namespace :indexer do
  desc "Explaining what the task does"
  task :schedule do
    IndexerManagerWorker.perform
  end
end
