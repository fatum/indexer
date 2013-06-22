module Indexer
  class Status < ActiveRecord::Base
    attr_accessible :last_processed_value, :name
  end
end
