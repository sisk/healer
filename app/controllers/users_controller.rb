class UsersController < ApplicationController
  inherit_resources

  respond_to :html, :json
  before_filter :authenticate_user!
  filter_resource_access

  before_filter :set_selectable_roles, :except => [:destroy]

  def index
    index! do |format|
      format.json {
        render :text => "{\"users\" : #{@users.to_json}}"
      }
    end
  end

  def create
    params[:user][:password] = params[:user][:password_confirmation] = random_password if params[:user][:password].blank?
    create! { users_path }
  end

  def update
    params[:user][:password] = params[:user][:password_confirmation] = random_password if params[:user][:password].blank?
    @user.update_attributes(params["user"])
    update! { edit_user_path(@user) }
  end

  private #####################################################################

  def set_selectable_roles
    @selectable_roles = Role::available
  end

  def collection
    @users = end_of_association_chain.search(params[:search]) if params[:search].present?
    @users ||= params[:inactive].present? ? end_of_association_chain.cant_login : end_of_association_chain.can_login
  end

  def random_password
    (0...8).map{65.+(rand(25)).chr}.join
  end
  # def update_resource(user, attributes)
  #   user.update_with_password(attributes)
  # end

end
