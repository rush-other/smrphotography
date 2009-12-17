# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_shannonmrush_session_id'
  
  before_filter :secure_check
  
  NO_SAVE_MSG_GALLERY = "Thank you for your interest.  Please click Order to purchase prints."
  NO_SAVE_MSG_ORDER = "Thank you for your interest.  Please click Add to Cart to purchase prints."
  NO_SAVE_MSG_HOME = "Thank you for your interest.  Please order prints through the client galleries."
  
private
  #Determine if the user has rights to view this page
  def secure_check
    unless controller_name == 'secure'
      #Set the last page you were trying to get to for login redirect
      session[:attempted_page] = {:controller => controller_name, :action => action_name}
    end
    if secure?
      user = logged_in_user
      if user.nil? || user.id.nil?
        goto_login = true
      elsif user.role != Role.find(required_role)
        goto_login = true
      else
        goto_login = false
      end
      if goto_login
        redirect_to :controller => 'secure', :action => 'login'
        return
      end
    end
  end
  
  #Return true if more than anonymous access is required
  def secure?
    required_role != ROLE_ANONYMOUS
  end
  
  #Default required role, override in each controller
  def required_role
    ROLE_ANONYMOUS
  end
  
  #Logged in user
  def logged_in_user
    if logged_in_user_id.nil?
      nil
    else
      user = User.find(logged_in_user_id)
      if user.nil? || !user.active
        nil
      else
        user
      end
    end
  end
  
  def logged_in_user_id
    session[:logged_in_user_id]
  end
  
  def set_logged_in_user(new_user)
    if new_user.nil?
      session[:logged_in_user_id] = nil
    else
      session[:logged_in_user_id] = new_user.id
    end
  end
  
end
