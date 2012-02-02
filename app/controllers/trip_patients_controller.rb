class TripPatientsController < ApplicationController
  inherit_resources
  defaults :resource_class => Patient, :collection_name => 'patients', :instance_name => 'patient'

  belongs_to :trip
  before_filter :authenticate_user!

  def index
    @body_parts_names = parent.patient_cases.map(&:body_part).uniq.compact.map(&:name_en).uniq

    @all_patients = collection
    @paginated_patients = collection.paginate( :page => params[:page], :per_page => 5 )
    index! do |format|
      format.html
      format.js { render :template => "trip_patients/index.js.erb", :layout => nil }
    end
  end

  private ######################################################################

  def begin_of_association_chain
    @trip
  end

  def collection
    if params[:patient_id]
      subset = end_of_association_chain.find_all_by_id(params[:patient_id])
    end
    if params[:filter]
      subset = end_of_association_chain

      filter = params[:filter]

      case filter[:authorized_status]
      when "authorized"
        subset = subset.authorized
      when "unauthorized"
        subset = subset.unauthorized
      end

      if filter[:body_parts]
        subset = subset.body_part_name(filter[:body_parts].to_a).ordered_by_id
      end

    else
      subset ||= end_of_association_chain.ordered_by_id
    end
    @trip_patients ||= subset
  end

end
