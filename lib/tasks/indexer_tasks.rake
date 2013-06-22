namespace :indexer do
  desc "Fill jobs for indexing"
  task :schedule => :environment do
    Indexer::ManagerWorker.new.perform
  end
end
