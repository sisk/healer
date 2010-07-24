class CreateProcedures < ActiveRecord::Migration
  def self.up
    create_table :procedures do |t|
      t.string :base_name
      t.string :code
      t.integer :display_order

      t.timestamps
    end
  end

  def self.down
    drop_table :procedures
  end
end
