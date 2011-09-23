class CaseGroup < ActiveRecord::Base
  has_many :patient_cases
  belongs_to :trip
  belongs_to :room
end
