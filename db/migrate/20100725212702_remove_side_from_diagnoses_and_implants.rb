class RemoveSideFromDiagnosesAndImplants < ActiveRecord::Migration
  def self.up
    remove_column :diagnoses, :side
    remove_column :implants, :side
  end

  def self.down
    add_column :implants, :side, :string
    add_column :diagnoses, :side, :string
  end
end
