class Facilities < ActiveRecord::Migration
  def self.up
    create_table :facilities, :force => true do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.timestamps
    end
    create_table :operating_rooms, :force => true do |t|
      t.string :title
      t.string :location
      t.integer :facility_id
      t.text :notes
      t.timestamps
    end
    add_column :operations, :operating_room_id, :integer
  end

  def self.down
    remove_column :operations, :operating_room_id
    drop_table :operating_rooms
    drop_table :facilities
  end
end