require 'spec_helper'

describe CaseGroup do
  should_have_column :schedule_order, :type => :integer
  should_have_column :room_id, :type => :integer
  should_have_column :scheduled_day, :type => :integer
  should_have_many :patient_cases
  should_belong_to :trip
  should_belong_to :room
end
