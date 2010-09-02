require 'spec_helper'

describe Registration do
  should_have_column :patient_id, :type => :integer
  should_have_column :approved_by_id, :type => :integer
  should_have_column :created_by_id, :type => :integer
  should_have_column :trip_id, :type => :integer
  should_have_column :approved_at, :type => :datetime

  should_belong_to :patient
  should_belong_to :trip
  should_belong_to :approved_by
  should_belong_to :created_by
  
  should_validate_presence_of :patient
  should_validate_presence_of :trip
end
