class ReviseRiskFactor < ActiveRecord::Migration
  def self.up
    add_column :risk_factors, :severity, :integer, :default => 0
    RiskFactor.reset_column_information
    RiskFactor.all.each do |risk_factor|
      severity = risk_factor.severe? ? 3 : 0
      risk_factor.update_attributes(:severity => severity)
    end
    remove_column :risk_factors, :severe
  end

  def self.down
    add_column :risk_factors, :severe, :boolean, :default => false
    RiskFactor.reset_column_information
    RiskFactor.all.each do |risk_factor|
      severe = risk_factor.severity == 3 ? true : false
      risk_factor.update_attributes(:severe => severe)
    end
    remove_column :risk_factors, :severity
  end
end
