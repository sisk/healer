class CreateDiseases < ActiveRecord::Migration
  def self.up
    create_table :diseases do |t|
      t.string :base_name
      t.string :code
      t.integer :display_order
      t.timestamps
    end
  end

  def self.down
    drop_table :diseases
  end
end
