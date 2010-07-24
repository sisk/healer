class MoveSideToDiagnosis < ActiveRecord::Migration
  def self.up
    add_column :diagnoses, :side, :string
    remove_column :operations, :side
  end

  def self.down
    add_column :operations, :side, :string
    remove_column :diagnoses, :side
  end
end
