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

  should_validate_presence_of :patient
  should_validate_presence_of :disease
  
  should_validate_numericality_of :severity
  should_validate_inclusion_of :severity, :in => 0..3
  should_validate_inclusion_of :side, :in => ["L", "R", nil]
end
