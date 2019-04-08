class CreateActivityLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :activity_logs do |t|
      t.integer :object_id, null: false
      t.string :object_type, null: false
      t.integer :timestamp, null: false # works until 2038 atleast
      t.jsonb :object_changes
      t.jsonb :object_state, null: false, default: {}

      t.timestamps null: false
    end

    add_index :activity_logs, [:object_id, :object_type, :timestamp]
  end
end
