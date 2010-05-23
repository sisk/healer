class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.date :start
      t.date :end
      t.string :country, :null => false
      t.string :city
      t.timestamps
    end
  end

  def self.down
    drop_table :trips
  end
end
