## Library currently extracting from internal project!!

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
