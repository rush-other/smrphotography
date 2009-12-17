module GalleryHelper
  
  def page_title
    titles = {
                'portraits' => "Gallery",
                'home' => "Gallery",
                'pricing' => "Pricing",
                'about' => "About",
                'contact' => "Contact",
                'client_galleries' => "Gallery",
                #TODO - This should be the name of the client
                'client_gallery' => "Gallery"
              }
    if titles.has_key?(controller.action_name)
      "Shannon M Rush Photography - " + titles[controller.action_name]
    else
      "Shannon M Rush Photography"
    end
  end
  
  def selected(page)
    if controller.action_name != 'client_gallery'
      #Page is selected if action is equal to page name
      controller.action_name == page
    else
      #The Client Gallery is selected
      return page == 'client_galleries'
    end
  end
  
  #Determine if the gallery is the selected gallery
  def gallery_selected(gallery)
    if not (flash[:gallery].blank? || gallery.nil?)
      if flash[:gallery].id == gallery.id
        return "selected='selected'"
      end
    end
    return ""
  end
  
  #Determine if the selected gallery is secure
  def gallery_secured?
    if flash[:gallery].blank?
      nil
    else
      not flash[:gallery].password.blank?
    end
  end
  
  #Render the links in the sidebar if there should be any
  def render_sidebar_menu_if_applicable
    if controller.action_name == 'client_gallery'
      render_partial "client_gallery_sidebar"
    end
  end
end
