class CameliatkEngineToVersion3 < ActiveRecord::Migration
  def self.up
    Rails.plugins["cameliatk_engine"].migrate(3)
  end

  def self.down
    Rails.plugins["cameliatk_engine"].migrate(0)
  end
end
