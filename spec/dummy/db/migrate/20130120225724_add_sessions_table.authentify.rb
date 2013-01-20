# This migration comes from authentify (originally 20120425220924)
class AddSessionsTable < ActiveRecord::Migration
  def up
    create_table :authentify_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :authentify_sessions, :session_id
    add_index :authentify_sessions, :updated_at
  end

  def down
    drop_table :authentify_sessions
  end
end
