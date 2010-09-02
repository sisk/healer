class AddNotesToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :notes, :text
  end

  def self.down
    remove_column :registrations, :notes
  end
end
