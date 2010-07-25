class PatientInteraction < ActiveRecord::Base
  belongs_to :provider, :class_name => "User", :foreign_key => "provider_id"
  belongs_to :patient, :class_name => "User", :foreign_key => "patient_id"
  validates_presence_of :patient_id
  validates_presence_of :date_time
  validates_presence_of :type
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

