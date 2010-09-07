class Registration < ActiveRecord::Base
  belongs_to :patient
  belongs_to :trip
  belongs_to :approved_by, :class_name => "User", :foreign_key => "approved_by_id"
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  validates_presence_of :patient
  validates_presence_of :trip
  accepts_nested_attributes_for :patient
  
  default_scope :include => :patient, :order => 'patients.name_last, patients.name_first'
  
  scope :authorized, :conditions => [ "registrations.approved_at is not ?", nil ]
  scope :unauthorized, :conditions => [ "registrations.approved_at is ?", nil ]  

  def to_s
    trip.to_s
  end

  def authorize!(approved_by_id = nil)
    self.update_attributes(:approved_by_id => approved_by_id, :approved_at => Time.now)
  end
  def deauthorize!
    self.update_attributes(:approved_by_id => nil, :approved_at => nil)
  end

  def authorized?
    !approved_at.blank?
  end
  
end
