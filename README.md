## Library currently extracting from internal project!!

### Installation

```
bundle install
bundle exec rake indexer:install:migrations
bundle exec rake db:migrate
```

### Configuration

```
indexers:
  keywords:
    retry: true
    limit: 1000
    indexer: Indexer::Keyword
  alexa_keywords:
    retry: true
    limit: 1000
    indexer: Indexer::AlexaKeyword
  snapshots:
    retry: true
    resque: true
    limit: 1000
    indexer: Indexer::Snapshot
```

### Initializer config/initializers/indexer.rb

```
Indexer::Manager.indexers = Settings.indexers
Indexer::ExecutorWorker.processed = lambda do |indexer, id|
  ap indexer
  ap id

  Metric.local_hit :indexer_processed
end

Indexer::ExecutorWorker.failed = lambda do |indexer, id, e|
  ap e
  ap indexer
  ap id

  Metric.local_hit :indexer_failed
end
```

### Indexer sample

```
class Indexer::Snapshot

  # Indexer-specific interface (:fetch_for_indexing, :run)
  def self.fetch_for_indexing(last_id, limit)
    # select * from entity where id > last_id limit 10
  end

  def self.run(entity_id)
    # indexer logic
  end
end
```

### Workers

```
snapshots: bundle exec rake resque:workers QUEUE=snapshots COUNT=10
```
OR
```
snapshots00: bundle exec sidekiq -q snapshots -c 15
```

And schedule periodically ```Indexer::ManagerWorker.run!``` in sidekiq or resque. Or run ```rake indexer:schedule```
