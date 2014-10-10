class ChangeActiveToEnabled < ActiveRecord::Migration
  def up
    remove_index :repos, :active
    remove_column :repos, :active
    add_column :repos, :enabled, :boolean, default: false, null: false
    add_index :repos, :enabled
  end

  def down
    remove_index :repos, :enabled
    remove_column :repos, :enabled
    add_column :repos, :active, :boolean, default: false, null: false
    add_index :repos, :active
  end
end
