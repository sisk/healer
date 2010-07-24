require 'spec_helper'

describe Diagnosis do
  it { should have_db_column(:patient_id).of_type(:integer) }
  it { should have_db_column(:body_part_id).of_type(:integer) }
  it { should have_db_column(:disease_id).of_type(:integer) }
  it { should have_db_column(:severity).of_type(:integer) }
  it { should have_db_column(:assessed_date).of_type(:date) }

  it { should belong_to(:patient) }
  it { should belong_to(:disease) }
  it { should belong_to(:body_part) }

  it { should validate_presence_of(:patient) }
  it { should validate_presence_of(:disease) }
  it { should validate_numericality_of(:severity) }
end
