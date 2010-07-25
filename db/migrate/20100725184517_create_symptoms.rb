class CreateSymptoms < ActiveRecord::Migration
  def self.up
    create_table :symptoms do |t|
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :symptoms
  end
end
