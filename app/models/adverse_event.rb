class AdverseEvent < ActiveRecord::Base

  belongs_to :patient
  validates_presence_of :patient
  belongs_to :entered_by, :class_name => "User", :foreign_key => "entered_by_id"

  def to_s
    "Event logged #{created_at}"
  end


end
