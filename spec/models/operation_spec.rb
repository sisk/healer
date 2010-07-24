require 'spec_helper'

describe Operation do
  it { should have_db_column(:procedure_id).of_type(:integer) }
  it { should have_db_column(:patient_id).of_type(:integer) }
  it { should have_db_column(:diagnosis_id).of_type(:integer) }
  it { should have_db_column(:primary_surgeon_id).of_type(:integer) }
  it { should have_db_column(:secondary_surgeon_id).of_type(:integer) }
  it { should have_db_column(:anesthesiologist_id).of_type(:integer) }
  it { should have_db_column(:date).of_type(:date) }
  it { should have_db_column(:approach).of_type(:string) }
  it { should have_db_column(:difficulty).of_type(:integer) }
  it { should have_db_column(:graft).of_type(:boolean) }
  it { should have_db_column(:notes).of_type(:text) }
  it { should have_db_column(:ambulatory_order).of_type(:string) }

  it { should belong_to(:procedure) }
  it { should belong_to(:patient) }
  it { should belong_to(:diagnosis) }
  it { should belong_to(:primary_surgeon) }
  it { should belong_to(:secondary_surgeon) }
  it { should belong_to(:anesthesiologist) }

  it { should validate_presence_of(:procedure) }
  it { should validate_presence_of(:patient) }
  it { should validate_presence_of(:date) }
  it { should validate_numericality_of(:difficulty) }
  it { should ensure_inclusion_of(:difficulty).in_range(0..2) }
end
