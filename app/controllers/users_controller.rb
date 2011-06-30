class UsersController < ApplicationController
  inherit_resources
  
  respond_to :html, :json
  before_filter :authenticate_user!
  filter_resource_access

  before_filter :set_selectable_roles, :except => [:create, :destroy]
  
  def index
    index! do |format|
      format.json {
        render :text => "{\"users\" : #{@users.to_json}}"
      }
    end
  end
  
  def create
    create! { users_path }
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    @user.update_attributes(params)
    update! { edit_user_path(@user) }
  end
  
private
  
  def set_selectable_roles
    @selectable_roles = Role::available
  end
  
  def collection
    @users = end_of_association_chain.search(params[:search]) if params[:search].present?
    @users ||= params[:inactive].present? ? end_of_association_chain.cant_login : end_of_association_chain.can_login
  end
  # def update_resource(user, attributes)
  #   user.update_with_password(attributes)
  # end

end
