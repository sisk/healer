class CaseGroup < ActiveRecord::Base
  has_many :patient_cases, :dependent => :nullify, :uniq => true
  belongs_to :trip
  belongs_to :room

  scope :with_n_cases, lambda {|n| {:joins => :patient_cases, :group => "patient_cases.case_group_id", :having => ["count(patient_cases.case_group_id) = ?", n]}}
  scope :with_gt_n_cases, lambda {|n| {:joins => :patient_cases, :group => "patient_cases.case_group_id", :having => ["count(patient_cases.case_group_id) > ?", n]}}

  def remove(the_case)
    # 1. Delete a case from the group by setting its foreign key to NULL
    patient_cases.delete(the_case)
    # 2. Destroy the case group entirely if no cases remain.
    self.destroy if patient_cases.empty?
  end

  def self.remove_orphans(trip_id)
    self.destroy_all("trip_id = #{trip_id} AND id NOT IN (SELECT case_group_id FROM patient_cases where trip_id = #{trip_id})")
  end

end
