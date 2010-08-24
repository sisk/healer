class CreateXrays < ActiveRecord::Migration
  def self.up
    create_table :xrays do |t|
      t.integer :diagnosis_id
      t.integer :operation_id
      t.datetime :date_time
      t.string :taken_at
      t.string :photo_file_name # Original filename
      t.string :photo_content_type # Mime type
      t.integer :photo_file_size # File size in bytes
      t.timestamps
    end
  end

  def self.down
    drop_table :xrays
  end
end
