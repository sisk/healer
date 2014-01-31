class Appointment < ActiveRecord::Base
  has_many :patient_cases, :dependent => :nullify, :uniq => true
  belongs_to :trip

  default_scope :order => 'appointments.schedule_order'

  scope :with_n_cases, lambda {|n| {:joins => :patient_cases, :group => "patient_cases.appointment_id", :having => ["count(patient_cases.appointment_id) = ?", n]}}
  scope :with_gt_n_cases, lambda {|n| {:joins => :patient_cases, :group => "patient_cases.appointment_id", :having => ["count(patient_cases.appointment_id) > ?", n]}}

  scope :unscheduled, where("appointments.room_number is ? or appointments.scheduled_day = ?", nil, 0)
  scope :scheduled, where("appointments.room_number is not ? and appointments.scheduled_day != ?", nil, 0)
  scope :room, lambda { |num| where("appointments.room_number = ?",num) if num.present? }
  scope :day, lambda { |num| where("appointments.scheduled_day = ?",num) if num.present? }
  scope :no_day, where("appointments.scheduled_day = ?",0)

  after_save :join_bilateral_cases

  has_many :operations, :through => :patient_cases

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
    self.destroy_all("trip_id = #{trip_id} AND id NOT IN (SELECT appointment_id FROM patient_cases where trip_id = #{trip_id} and appointment_id is not null)")
  end

  def bilateral?
    anatomy_sides.size == 2 && anatomies.size == 1 && patient_case_trips_match?
  end

  def unschedule!
    update_attributes!({ :room_number => nil, :scheduled_day => 0 })
  end

  # TODO js: kill this!
  def join_bilateral_cases
    return if bilateral?
    # TODO this seems way too hacky. Reeking of poor design. Make it better.
    patient_cases.group_by{ |pc| pc.anatomy }.each do |anatomy, cases|
      if cases.size == 2
        # Very likely this is a bilateral scenario. Set each to the other's bilateral.
        cases[0].update_column(:bilateral_case_id, cases[1].id)
        cases[1].update_column(:bilateral_case_id, cases[0].id)
      end
    end
  end

  # TODO js: this should be a decorator concern only
  # i.e. appointment was "knee" or "hip" even if bilateral
  def likely_anatomy
    patient_cases.map(&:anatomy).first
  end

  # TODO js: this should be a decorator concern only
  def any_revisions?
    patient_cases.any?{ |pc| pc.revision? }
  end

  # TODO js: this should be a decorator concern only
  def surgeons
    (patient_cases.map(&:primary_surgeon) + patient_cases.map(&:secondary_surgeon)).flatten.compact
  end

  def anatomies
    anatomy_info.map{ |v| v[0] }.uniq
  end

  def anatomy_sides
    anatomy_info.map{ |v| v[1] }.uniq
  end


  private #####################################################################

  def anatomy_info
    @anatomy_info ||= patient_cases.map{ |pc| [pc.anatomy,pc.side] }
  end

  def patient_case_trips_match?
    trip_ids = patient_cases.map(&:trip_id).uniq
    trip_ids.size == 1 && trip_ids[0] == trip_id
  end

end
