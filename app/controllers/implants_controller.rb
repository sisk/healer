class ImplantsController < ApplicationController

  # sisk 2011-02-16
  # Generally, this controller could use some work. There seems to be issues with STI and inherited_resources,
  # and I'm in too much of a hurry to dig in right now. Going the hacky route and abandoning elegance for a bit...
  before_filter :setup_operation

  def new
    @implant = setup_implant_type(@operation)
  end

  def show
    @implant = @operation.implant
  end

  def edit
    @implant = @operation.implant
  end

  def create
    @implant = setup_implant_type(@operation)
    @implant.attributes = params[@implant.type.underscore]
    if @implant.save
      redirect_to operation_path(@operation), :notice => "Implant created."
    else
      render :action => "new", :error => "Error creating implant."
    end
  end

  def update
    @implant = @operation.implant
    @implant.attributes = params[@implant.type.underscore]
    if @implant.save
      redirect_to operation_path(@operation), :notice => "Implant updated."
    else
      render :action => "edit", :error => "Error saving implant."
    end
  end

  private
  
  def setup_implant_type(operation)
    return operation.implant if operation.implant.present?

    case operation.body_part.try(:name_en).try(:downcase)
    when "knee"
      KneeImplant.new(:operation => operation, :body_part => operation.body_part)
    when "hip"
      HipImplant.new(:operation => operation, :body_part => operation.body_part)
    else
      Implant.new(:operation => operation, :body_part => operation.body_part)
    end
  end

  def setup_operation
    @operation = Operation.find(params[:operation_id])
  end

end
