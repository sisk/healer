class OperationsController < ApplicationController
  inherit_resources

  respond_to :html, :xml, :json
  belongs_to :case, :parent_class => PatientCase, :singleton => true, :optional => true
  # This controller is used as a singleton resource. For some reason, declarative_authorization doesn't like the use of
  # filter_resource_access here when trying to call #show. Therefore, change it up a little for this controller.
  filter_access_to :all

  def index
    index! do |format|
      format.json {
        render :text => "{\"operations\" : #{@operations.to_json}}"
      }
    end
  end

  def new
    new! do |format|
      format.js { render :template => "operations/new.js.erb", :layout => nil }
    end
  end

  def show
    show! {
      if resource
        if I18n.locale == :es
          # Patient certificate
          render :layout => "patient_certificate" and return
        end
      else
        flash[:error] = "No operation exists for this case."
        redirect_to parent_path and return
      end
    }
  end

  def edit
    edit! do |format|
      format.html {
        if !resource
          flash[:error] = "No operation exists for this case."
          redirect_to parent_path and return
        end
      }
      format.js { render :template => "operations/edit.js.erb", :layout => nil }
    end
  end

  def create
    create! do |format|
      format.html { redirect_to case_operation_path(parent) }
      format.js { render :template => "operations/create.js.erb", :layout => nil }
    end
  end

  def update
    update! do |format|
      format.html { redirect_to case_operation_path(parent), :notice => "Operation updated." }
      format.js { render :template => "operations/update.js.erb", :layout => nil }
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to parent_path }
      format.js { render :template => "operations/destroy.js.erb", :layout => nil }
    end
  end

  private

  # NOTE: This very presence of this override is a hack. Likely due to singleton.
  # Lifted a fix from https://github.com/josevalim/inherited_resources/issues/136
  # Keep an eye on future versions of inherited_resources to see if its need goes away
  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.is_a?(Class) ? end_of_association_chain.find(params[:id]) : end_of_association_chain.send(resource_instance_name))
  end

  def parent
    # normally, this shouldn't be needed. however, IR doesn't seem to handle the polymorphism combined with parent_class.
    @parent = PatientCase.find_by_id(params[:case_id])
  end

  def parent_path
    # normally, this shouldn't be needed. however, IR doesn't seemto handle the polymorphism combined with parent_class.
    return case_path(PatientCase.find(params[:case_id])) if params[:case_id]
  end

  def build_resource
     super
     @operation.date = Date.today if @operation.new_record?
     @operation
  end

end
