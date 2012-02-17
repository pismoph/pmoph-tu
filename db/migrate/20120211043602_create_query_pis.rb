class CreateQueryPis < ActiveRecord::Migration
  def self.up
    create_table :query_pis do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :query_pis
  end
end
