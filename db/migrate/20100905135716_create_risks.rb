class CreateRisks < ActiveRecord::Migration
  def self.up
    create_table :risks do |t|
      t.string :name
      t.integer :display_order

      t.timestamps
    end
  end

  def self.down
    drop_table :risks
  end
end
