class CreateRiskFactors < ActiveRecord::Migration
  def self.up
    create_table :risk_factors do |t|
      t.integer :patient_id
      t.integer :risk_id
      t.boolean :severe, :default => false, :nil => false

      t.timestamps
    end
  end

  def self.down
    drop_table :risk_factors
  end
end
