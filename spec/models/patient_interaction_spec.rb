require 'spec_helper'

describe PatientInteraction do
  # it_has_the_attribute :notes, :type => :text
  it{should belong_to(:patient)}
  it{should belong_to(:provider)}
  it{should validate_presence_of(:patient_id)}
end

# == Schema Information
#
# Table name: patient_interactions
#
#  id          :integer(4)      not null, primary key
#  patient_id  :integer(4)      not null
#  provider_id :integer(4)
#  notes       :text
#  created_at  :datetime
#  updated_at  :datetime
#

