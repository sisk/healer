class ProceduresController < InheritedResources::Base
  actions :all, :except => [ :sort ]
  # before_filter :authenticate_user!
  filter_resource_access :collection => [:index, :sort]
  
  def create
    create! { procedures_path }
  end
  
  def update
    update! { procedures_path }
  end
  
  def sort
    params[:procedure].each_with_index do |id, index|
      Procedure.update_all(['display_order = ?', index + 1], ['id = ?', id.to_i])
    end
    render :nothing => true
  end

end
