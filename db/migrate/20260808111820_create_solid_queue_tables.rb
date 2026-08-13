class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def up
    # Force loads the isolated schema cleanly into your unified database
    schema_file = Rails.root.join("db/queue_schema.rb")

    if File.exist?(schema_file)
      load(schema_file)
    else
      raise "Solid Queue schema file not found at #{schema_file}."
    end
  end

  def down
    # Drops the tables cleanly if you ever roll back this migration
    drop_table :solid_queue_jobs, if_exists: true
    drop_table :solid_queue_processes, if_exists: true
    drop_table :solid_queue_ready_jobs, if_exists: true
    drop_table :solid_queue_scheduled_jobs, if_exists: true
    drop_table :solid_queue_blocked_jobs, if_exists: true
    drop_table :solid_queue_failed_jobs, if_exists: true
    drop_table :solid_queue_semaphores, if_exists: true
    drop_table :solid_queue_pauses, if_exists: true
    drop_table :solid_queue_recurring_tasks, if_exists: true
  end
end
