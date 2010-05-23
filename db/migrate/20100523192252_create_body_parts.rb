class CreateBodyParts < ActiveRecord::Migration
  def self.up
    create_table :body_parts do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :body_parts
  end
end
