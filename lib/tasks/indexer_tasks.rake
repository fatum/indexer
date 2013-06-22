namespace :indexer do
  desc "Fill jobs for indexing"
  task :schedule => :environment do
    Indexer::Manager.run!
  end
end
