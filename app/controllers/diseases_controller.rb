class DiseasesController < InheritedResources::Base
  actions :all, :except => [ :sort ]
  before_filter :authenticate_user!
  filter_resource_access :collection => :sort

  def create
    create! { diseases_path }
  end

  def update
    update! { diseases_path }
  end

  def sort
    params[:disease].each_with_index do |id, index|
      Disease.update_all(['display_order = ?', index + 1], ['id = ?', id.to_i])
    end
    render :nothing => true
  end

end
