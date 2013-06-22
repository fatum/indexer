class CreateIndexerStatuses < ActiveRecord::Migration
  def change
    create_table :indexer_statuses do |t|
      create_table :indexer_statuses do |t|
      t.string :name, null: false
      t.integer :last_processed_value, null: false, default: 0

      t.timestamps
    end

    add_index :indexer_statuses, [:name, :last_processed_value], unique: true
  end
end
