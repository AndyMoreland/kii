class UsersController < ApplicationController
  before_filter :require_registration_enabled
  
  def show
    @user = User.find_by_login!(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      UserSession.create(@user)
      redirect_to user_path(@user)
    else
      render :action => "new"
    end
  end
  
  private
  
  def require_registration_enabled
    redirect_to root_path unless Kii::CONFIG[:public_registration]
  end
end
