class CaseGroup < ActiveRecord::Base
  has_many :patient_cases, :dependent => :nullify, :uniq => true
  belongs_to :trip

  default_scope :order => 'case_groups.schedule_order'

  scope :with_n_cases, lambda {|n| {:joins => :patient_cases, :group => "patient_cases.case_group_id", :having => ["count(patient_cases.case_group_id) = ?", n]}}
  scope :with_gt_n_cases, lambda {|n| {:joins => :patient_cases, :group => "patient_cases.case_group_id", :having => ["count(patient_cases.case_group_id) > ?", n]}}

  scope :unscheduled, where("case_groups.room_number is ? or case_groups.scheduled_day = ?", nil, 0)
  scope :scheduled, where("case_groups.room_number is not ? and case_groups.scheduled_day != ?", nil, 0)
  scope :room, lambda { |num| where("case_groups.room_number = ?",num) if num.present? }
  scope :day, lambda { |num| where("case_groups.scheduled_day = ?",num) if num.present? }
  scope :no_day, where("case_groups.scheduled_day = ?",0)

  def patient
    @patient ||= patient_cases.first.try(:patient)
  end

  def remove(the_case)
    # 1. Delete a case from the group by setting its foreign key to NULL
    patient_cases.delete(the_case)
    # 2. Destroy the case group entirely if no cases remain.
    self.destroy if patient_cases.empty?
  end

  def self.remove_orphans(trip_id)
    self.destroy_all("trip_id = #{trip_id} AND id NOT IN (SELECT case_group_id FROM patient_cases where trip_id = #{trip_id})")
  end

  # def schedule!
  #   self.status = "Scheduled" if ["Registered","Unscheduled"].include?(self.status)
  #   self.save
  # end

  def unschedule!
    update_attributes({ :room_number => nil, :scheduled_day => 0 })
  end

end
