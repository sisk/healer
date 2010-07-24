require 'spec_helper'

describe PatientInteraction do
  should_have_column :patient_id, :type => :integer
  should_have_column :provider_id, :type => :integer
  should_have_column :notes, :type => :text

  should_validate_presence_of :patient_id

  should_belong_to :patient
  should_belong_to :provider
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

