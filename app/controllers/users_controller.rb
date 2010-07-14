class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :new, :create]

  def index
    redirect_to root_path
  end

  def new
    @user = User.new
    render :layout => "blank"
  end

  def edit
    @user = User.find_by_id(params[:id])
    unless @user
      flash[:error] = "User not found."
      redirect_to root_path
      return
    end
    render :layout => "application"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_path
    else
      flash[:error] = "Registration failed."
      render :action => "new"
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated."
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "Profile save failed."
      render :action => "edit"
    end
  end

end