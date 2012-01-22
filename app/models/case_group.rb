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

  after_save :join_bilateral_cases

  def to_s
    bilateral? ? "#{patient_cases.map{ |pc| pc.body_part.display_name }.uniq.join(", ")} (Bilateral)" : patient_cases.map{ |pc| pc.body_part.to_s }.join(", ")
  end

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
    self.destroy_all("trip_id = #{trip_id} AND id NOT IN (SELECT case_group_id FROM patient_cases where trip_id = #{trip_id} and case_group_id is not null)")
  end

  def bilateral?
    patient_cases.size > 1 && patient_cases.any?{ |pc| pc.bilateral_case.present? }
  end

  # def schedule!
  #   self.status = "Scheduled" if ["Registered","Unscheduled"].include?(self.status)
  #   self.save
  # end

  def unschedule!
    update_attributes({ :room_number => nil, :scheduled_day => 0 })
  end

  private #####################################################################

  def join_bilateral_cases
    return if bilateral?
    # TODO this seems way too hacky. Reeking of poor design. Make it better.
    patient_cases.group_by{ |pc| pc.body_part.name_en }.each do |body_part_name, cases|
      if cases.size == 2
        # Very likely this is a bilateral scenario. Set each to the other's bilateral.
        cases[0].bilateral=(cases[1])
        cases[1].bilateral=(cases[0])
      end
    end
  end

end
