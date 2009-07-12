class ApplicationController < ActionController::Base
  LacksWriteAccess = Class.new(RuntimeError)
  
  # To avoid encoding issues on page names such as '/Øystein' on ruby 1.9
  if String.method_defined?(:force_encoding)
    before_filter {|c| c.params.each {|k, v| v.force_encoding("UTF-8") if v.is_a?(String) }}
  end
  
  protect_from_forgery
  filter_parameter_logging :password
  
  private
  
  def current_user
    return @current_user if defined?(@current_user)
    user_session = UserSession.find
    @current_user = user_session && user_session.user
  end
  
  def logged_in?
    current_user.is_a?(User)
  end
  
  def write_access?
    Kii::CONFIG[:public_write] || logged_in?
  end
  
  def require_write_access
    raise LacksWriteAccess unless write_access?
  end
  
  def require_login
    redirect_to new_session_path unless logged_in?
  end
  
  helper_method :current_user, :logged_in?, :write_access?, :registration_enabled?
end
