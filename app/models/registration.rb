class Registration < ActiveRecord::Base
  belongs_to :patient
  belongs_to :trip
  belongs_to :approved_by, :class_name => "User", :foreign_key => "approved_by_id"
  validates_presence_of :patient
  validates_presence_of :trip
end
