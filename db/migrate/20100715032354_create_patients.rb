class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.string :name_first
      t.string :name_last
      t.string :name_middle
      t.date :birth
      t.date :death
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone
      t.boolean :male, :default => false
      t.decimal :height_cm, :precision => 10, :scale => 2
      t.decimal :weight_kg, :precision => 10, :scale => 2
      t.string :photo_file_name # Original filename
      t.string :photo_content_type # Mime type
      t.integer :photo_file_size # File size in bytes
      t.timestamps
    end
  end

  def self.down
    drop_table :patients
  end
end
