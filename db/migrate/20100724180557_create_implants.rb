class CreateImplants < ActiveRecord::Migration
  def self.up
    create_table :implants do |t|
      t.string :type
      t.integer :operation_id
      t.integer :body_part_id
      t.string :side
      t.boolean :cement_used
      t.boolean :spacer_used
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :implants
  end
end
