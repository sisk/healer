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
      redirect_to root_path, :error => "No current trip."
    end
  end

  private #####################################################################

  def authenticate
    authenticate_user! unless signed_in?
  end

  def report_hash(trip, day_number = nil)
    if day_number.nil?
      # totals
      appointments = trip.appointments.scheduled
    else
      # per day
      appointments = trip.appointments.day(day_number)
    end

    if params[:surgeon_id].present?
      @surgeon = User.find(params[:surgeon_id])
      appointments.reject!{ |app| !app.surgeons.include?(@surgeon) }
    end

    males = appointments.select{ |app| app.patient.male? }
    females = appointments.select{ |app| !app.patient.male? }
    patient_cases = appointments.map(&:patient_cases).flatten
    unique_anatomies = patient_cases.map{ |pc| pc.anatomy }.uniq.compact.sort

    hash = {
      "Total Patients" => appointments.size,
      "Total Male" => males.size,
      "Total Female" => females.size,
      :surgeries => {
        :bilateral => {},
        :revision => {},
        :individual => {},
        :total_cases => 0
      }
    }
    unique_anatomies.each do |anatomy|
      individual_count = patient_cases.select{ |pc| pc.anatomy == anatomy }.size
      bilateral_count = appointments.select{ |app| (app.bilateral? && !app.any_revisions?) }.select{ |app| app.likely_anatomy == anatomy }.size
      revision_count = patient_cases.select{ |pc| pc.revision? && (pc.anatomy == anatomy) }.size
      hash[:surgeries][:bilateral][anatomy] = bilateral_count
      hash[:surgeries][:revision][anatomy] = revision_count
      hash[:surgeries][:individual][anatomy] = individual_count
      hash[:surgeries][:total_cases] += individual_count
    end

    return hash
  end

end
