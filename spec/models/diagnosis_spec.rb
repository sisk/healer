require 'spec_helper'

describe Diagnosis do
  should_have_column :patient_id, :type => :integer
  should_have_column :body_part_id, :type => :integer
  should_have_column :disease_id, :type => :integer
  should_have_column :severity, :type => :integer, :default => 0
  should_have_column :assessed_date, :type => :date
  should_have_column :side, :type => :string

  should_belong_to :patient
  should_belong_to :disease
  should_belong_to :body_part
  should_have_many :operations

  should_validate_presence_of :patient
  should_validate_presence_of :disease
  
  should_validate_numericality_of :severity
  should_validate_inclusion_of :severity, :in => Diagnosis::severity_table.keys
  should_validate_inclusion_of :side, :in => ["L", "R", nil]
end

describe Diagnosis, ".severity_table" do
  it "returns an indexed hash of the expected values" do
    Diagnosis::severity_table.should == { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
end