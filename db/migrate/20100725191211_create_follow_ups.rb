class CreateFollowUps < ActiveRecord::Migration
  def self.up
    create_table :follow_ups_symptoms, :id => false, :force => true do |t|
      t.integer :follow_up_id
      t.integer :symptom_id
      t.timestamps
    end
  end

  def self.down
    drop_table :follow_ups
  end
end
