class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  
  protected
  
  def ensure_logged_in
    if request.format === :json
      if user = authenticate_or_request_with_http_basic{ |u, p| User.authenticate(u, p) }
        p 'setting current user'
        @current_user = user
      end
    else
      unless session[:user_id]
        flash[:notice] = "You need to log in first."
        redirect_back_or_default
        return false
      else
        return true
      end
    end
  end
  
  def redirect_back_or_default
    begin
      redirect_to :back #if request.env["HTTP_REFERER"].nil? then it raises an exception which I rescue to go to the base url
    rescue
      redirect_to root_url
    end
  end
  
  private
  
  # return the current user object if someone is authenticated properly otherwise return false
  def current_user
    if request.format === :json
      return @current_user
    else    
     return @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
end





