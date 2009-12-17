class SecureController < ApplicationController
  def login
    
  end
  
  def do_login
    logged_in_user = nil
    if params[:username].blank? || params[:password].blank?
      flash[:messages] = ["Username or password are blank"]
    else
      user = User.find(:first, :conditions => ["username = ? and password = ?", params[:username], params[:password]])
      if user.nil? || user.id.nil?
        flash[:messages] = ["User " + params[:username] + " not found."]
      else
        #Success, set the logged in user
        set_logged_in_user user
        do_redirect
        return
      end
    end
    redirect_to :action => 'login'
  end
  
  def logout
    set_logged_in_user nil
    redirect_to :action => 'login'
  end
  
private
  def do_redirect
    if session[:attempted_page].blank?
      #Redirect to admin if the user is an admin
      if logged_in_user.role.name == 'admin'
        redirect_to :controller => 'admin', :action => 'photo_log'
      else
        redirect_to :controller => 'gallery', :action => 'home'
      end
    else
      redirect_to session[:attempted_page]
    end
  end
end
