class TripsController < ApplicationController
  inherit_resources
  actions :all, :except => [ :current ]

  before_filter :authenticate
  filter_resource_access :collection => [:index, :current, :reports]

  def index
    if params[:jump_to]
      trip = Trip.find(params[:jump_to])
      redirect_to trip_path(trip) if trip
    end
    @future_trips = end_of_association_chain.future
    @past_trips = end_of_association_chain.past
    @current_trips = end_of_association_chain.current
  end

  def show
    @authorized_patient_cases = @trip.patient_cases.authorized
  end

  def create
    create! { trips_path }
  end

  def update
    update! { trips_path }
  end

  def summary_report
    @trip = Trip.find(params[:id])
    @report = {}
    @trip.number_of_operation_days.times do |i|
      day_num = i + 1
      @report["Day #{day_num}"] = report_hash(@trip, day_num)
    end
    @report[:totals] = report_hash(@trip)
  end

  def day_report
    @trip = Trip.find(params[:id])
    @report = {}
    @day_num = params[:day]
    @report["Day #{@day_num}"] = report_hash(@trip, @day_num)
  end

  def current
    current_trip = Trip.current.first
    if current_trip
      redirect_to trip_path(current_trip)
    else
      redirect_to :back, :error => "No current trip."
    end
  end

  private #####################################################################

  def authenticate
    authenticate_user! unless signed_in?
  end

  def report_hash(trip, day_number = nil)
    if day_number.nil?
      # totals
      case_groups = trip.case_groups.scheduled
    else
      # per day
      case_groups = trip.case_groups.day(day_number)
    end

    if params[:surgeon_id].present?
      @surgeon = User.find(params[:surgeon_id])
      case_groups.reject!{ |cg| !cg.surgeons.include?(@surgeon) }
    end

    males = case_groups.select{ |cg| cg.patient.male? }
    females = case_groups.select{ |cg| !cg.patient.male? }
    patient_cases = case_groups.map(&:patient_cases).flatten
    unique_body_parts = patient_cases.map{ |pc| pc.body_part.try(:name_en) }.uniq.compact.sort

    hash = {
      "Total Patients" => case_groups.size,
      "Total Male" => males.size,
      "Total Female" => females.size,
      :surgeries => {
        :bilateral => {},
        :revision => {},
        :individual => {},
        :total_cases => 0
      }
    }
    unique_body_parts.each do |body_part_name|
      individual_count = patient_cases.select{ |pc| pc.body_part.try(:name_en) == body_part_name }.size
      bilateral_count = case_groups.select{ |cg| (cg.bilateral? && !cg.any_revisions?) }.select{ |cg| cg.likely_body_part.name_en == body_part_name }.size
      revision_count = patient_cases.select{ |pc| pc.revision? && (pc.body_part.try(:name_en) == body_part_name) }.size
      hash[:surgeries][:bilateral][body_part_name] = bilateral_count
      hash[:surgeries][:revision][body_part_name] = revision_count
      hash[:surgeries][:individual][body_part_name] = individual_count
      hash[:surgeries][:total_cases] += individual_count
    end

    return hash
  end

end
