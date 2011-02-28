class ProsthesisTypeForHip < ActiveRecord::Migration
  def self.up
    add_column :implants, :prosthesis_type, :string
  end

  def self.down
    remove_column :implants, :prosthesis_type
  end
end