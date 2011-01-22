class RisksController < ApplicationController
  inherit_resources
  
  actions :all, :except => [ :sort ]
  before_filter :authenticate_user!
  filter_resource_access :collection => [:index, :sort]

  def create
    create! { risks_path }
  end

  def update
    update! { risks_path }
  end

  def sort
    params[:risk].each_with_index do |id, index|
      Risk.update_all(['display_order = ?', index + 1], ['id = ?', id.to_i])
    end
    render :nothing => true
  end

end
