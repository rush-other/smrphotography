# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  DEFAULT_CSS = 'public/stylesheets/default.css'
  LIVE_HOME = "http://shannonmrush.com/"
  DEVEL_HOME = "http://localhost:3002/"
  
  @odd = false
  
  #Get the odd/even CSS class
  def odd_even
    @odd = (not @odd)
    if @odd
      "odd"
    else
      "even"
    end
  end
  
  #Return the time stamp of the modification date for the default css
  def css_time_stamp
    return File.new(DEFAULT_CSS).mtime.to_i
  end
  
  #Get the full link to the home page
  def link_to_home
    if RAILS_ENV == 'development'
      DEVEL_HOME
    else
      LIVE_HOME
    end
  end
  
  #Get the absolute link to a resource
  def absolute_link(rel)
    link_to_home + rel
  end
  
  #Get the path to an image
  def img_path(img)
    absolute_link("images/" + img)
  end
  
end
