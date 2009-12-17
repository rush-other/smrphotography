class GalleryController < ApplicationController
  layout 'main_frame'
  
  #####################
  #PAGES
  #####################
  
  #Home page
  def home
    initialize_home_page
  end
  
  #Portraits page
  def portraits
    initialize_portrait_page
  end
  
  #Pricing page
  def pricing
    
  end
  
  #About page
  def about
    
  end
  
  #Contact page
  def contact
    
  end
  
  #Success page
  def success
    
  end
  
  #Current project
  def current
    
  end
  def current_subscribe
    
  end
  
  #Main client galleries page - Login
  def client_galleries
    @galleries = Gallery.find(:all, :conditions => "active = 1")
    @secure_ids = []
    @galleries.each do |gallery|
      @secure_ids << gallery.id unless gallery.password.blank?
    end
  end
  
  #Individual client galleries
  def client_gallery
    if params[:client].blank?
      redirect_to :action => "client_galleries"
      return
    else
      @gallery = Gallery.find_by_context(params[:client])
      if @gallery.nil?
        #Redirect back to the list of galleries to choose from
        flash[:messages] = ["Unable to find a gallery at '/galleries/" + params[:client] + ".html'"]
        redirect_to :action => "client_galleries"
        return
      else
        if not @gallery.password.blank?
          found = false
          #Make sure the user has validated against this gallery already
          if not session[:validated_galleries].blank?
            session[:validated_galleries].each do |gallery|
              if @gallery == gallery
                found = true
              end
            end
          end
          if not found
            #Unvalidated secure gallery
            flash[:messages] = ["The gallery at '/galleries/" + params[:client] + ".html' is a secure gallery.  Please login."]
            flash[:gallery] = @gallery
            redirect_to :action => "client_galleries"
            return
          end
        end
      end
    end
    #If you get this far, you are okay.  Figure out what shoot to show
    if @gallery.shoots.blank?
      #No shoots to show
      @shoot = nil
    elsif params[:shoot].blank?
      #Just use the first shoot for the selected gallery
      @shoot = @gallery.shoots.first
    else
      #Otherwise, try to use the shoot in the params
      @shoot = Shoot.find(params[:shoot])
      if @shoot.gallery != @gallery
        #Oops, can't get to this shoot from this URL, go to the first shoot
        @shoot = @gallery.shoots.first
      end
    end
    #Now set up the session
    initialize_client_gallery_page(@shoot)
  end
  
  #Post to this to choose a gallery
  def select_gallery
    #Verify params
    if params[:gallery].blank?
      flash[:messages] = ["Please select a gallery."]
      redirect_to :action => "client_galleries"
      return
    else
      gallery = Gallery.find(params[:gallery])
      if not gallery.password.blank?
        #Verify password submitted
        if params[:password].blank?
          flash[:messages] = ["The gallery you are trying to log into is secure.  Please enter a valid password."]
          flash[:gallery] = gallery
          redirect_to :action => "client_galleries"
          return
        elsif params[:password] != gallery.password
          flash[:messages] = ["The password you entered was incorrect.  Please re-enter the gallery password."]
          flash[:gallery] = gallery
          redirect_to :action => "client_galleries"
          return
        end
      end
      #Validation passed
      #Add this to the list of validated galleries if needed
      if not gallery.password.blank?
        if session[:validated_galleries].blank?
          session[:validated_galleries] = [gallery]
        else
          session[:validated_galleries] << gallery
        end
      end
      #And go to the gallery
      redirect_to "/galleries/" + gallery.context + ".html"
    end
  end
  
  ##############################
  #AJAX CALLS
  ##############################
  def update_slide_on_home
    #Make sure the session params are initialized
    if session[:home_index].nil?
      initialize_home_page
    end
    #Now get the next photo and render it
    index = session[:home_index]
    ids = session[:home_photo_ids]
    if ids.empty?
      render_text ""
    else
      #increment the index for the next call
      if params[:next] == "true"
        index += 1
        index = 0 if index >= ids.size
      else
        index -= 1
        index = ids.size - 1 if index < 0
      end
      session[:home_index] = index
      photo = Photo.find(ids[index])
      #Call the renderer
      render_partial "photo_viewer", nil, 'photo' => photo, 'msg' => NO_SAVE_MSG_HOME
    end
  end
  #This sends the actual photo data back to the photo_viewer partial
  def home_image
    #Get the photo from params
    if params[:id].blank?
      ""
    else
      photo = Photo.find(params[:id])
      if photo.nil?
        ""
      else
        #Render the photo
        send_data photo.photo, :filename => photo.orig_file_name
      end
    end
  end
  
  def update_slide_on_portrait
    #Make sure the session params are initialized
    if session[:portrait_index].nil?
      initialize_portrait_page
    end
    #Now get the next photo and render it
    index = session[:portrait_index]
    ids = session[:portrait_photo_ids]
    if ids.empty?
      render_text ""
    else
      #increment the index for the next call
      if params[:next] == "true"
        index += 1
        index = 0 if index >= ids.size
      else
        index -= 1
        index = ids.size - 1 if index < 0
      end
      session[:portrait_index] = index
      photo = Photo.find(ids[index])
      #Call the renderer
      render_partial "photo_viewer", nil, 'photo' => photo, 'msg' => NO_SAVE_MSG_HOME
    end
  end
  #This sends the actual photo data back to the photo_viewer partial
  def portrait_image
    #Get the photo from params
    if params[:id].blank?
      ""
    else
      photo = Photo.find(params[:id])
      if photo.nil?
        ""
      else
        #Render the photo
        send_data photo.photo, :filename => photo.orig_file_name
      end
    end
  end
  
  def update_slide_on_client_gallery
    #Make sure the session params are initialized
    if session[:client_gallery_index].nil?
      initialize_client_gallery_page
    end
    #Now get the next photo and render it
    index = session[:client_gallery_index]
    photos = session[:client_gallery]
    if photos.empty?
      render_text ""
    else
      #increment the index
      if not params[:number].blank?
        #Get the slide by its number
        photos.each_with_index do |p, i|
          if p["number"].to_s == params[:number].to_s
            session[:client_gallery_index] = i
            photo = Photo.find(p["id"])
            #Call the renderer
            render_partial "photo_viewer", nil, 'photo' => photo, 'msg' => NO_SAVE_MSG_GALLERY
            return
          end
          render_text ""
        end
      else
        #Get the slide by id
        if params[:next] == "true"
          index += 1
          index = 0 if index >= photos.size
        else
          index -= 1
          index = photos.size - 1 if index < 0
        end
        session[:client_gallery_index] = index
        photo = Photo.find(photos[index]["id"])
        #Call the renderer
        render_partial "photo_viewer", nil, 'photo' => photo, 'msg' => NO_SAVE_MSG_GALLERY
      end
    end
  end
  #This sends the actual photo data back to the photo_viewer partial
  def client_gallery_image
    #Get the photo from params
    if params[:id].blank?
      ""
    else
      photo = Photo.find(params[:id])
      if photo.nil?
        ""
      else
        #Render the photo
        send_data photo.photo, :filename => photo.orig_file_name
      end
    end
  end
  ####
  #Make the function for submitting an email address
  # to subscribe to the newsletter
  def subscribe
    if params[:email].blank?
      render_text "<div class='messages'>Please enter an email address</div>"
    elsif params[:email] =~ /(.+)@(.+)\.(.{3})/
      if params[:page] == 'current'
        #Test uniqueness
        if VeganProjectSubscriber.find(:all, :conditions => "email = '" + params[:email] + "'").blank?
          subscriber = VeganProjectSubscriber.new()
        else
          render_text "<div class='messages'>You have already subscribed.  Thanks!</div>"
          return
        end
      else
        #Test uniqueness
        if NewsletterSubscriber.find(:all, :conditions => "email = '" + params[:email] + "'").blank?
          subscriber = VeganProjectSubscriber.new()
        else
          render_text "<div class='messages'>You have already subscribed.  Thanks!</div>"
          return
        end
        subscriber = NewsletterSubscriber.new()
      end
      subscriber.email = params[:email]
      if subscriber.save
        render_text "<div class='success_messages'>You have subscribed!</div>"
      else
        render_text "<div class='messages'>Sorry, there was a problem saving your email address.</div>"
      end
    else
      render_text "<div class='messages'>Please enter a valid email address</div>"
    end
  end
  
  def order
    @msg = NO_SAVE_MSG_ORDER
    if params[:id].blank?
      @photo = nil
    else
      @photo = Photo.find(params[:id])
      unless @photo.nil? 
        @photo_desc = "(Shoot: " + @photo.shoot.shoot_name + ", Number: " + @photo.number.to_s + ")"
      end
    end
  end
  
  ##############################
  #HELPER METHODS
  ##############################
private
  def required_roles
    #This is not a secure page
    nil
  end
  
  #Initialize the photo list for the home page
  def initialize_home_page
    session[:home_photo_ids] = Photo.find_ids("active = 1 and show_on_home = 1")
    if session[:home_photo_ids].blank?
      session[:home_index] = 0
    else
      session[:home_index] = (Time.now.to_i % session[:home_photo_ids].size)
    end
  end
  
  #Initialize the photo list for the home page
  def initialize_portrait_page
    #Get all the active photo_categories under the 'portrait' category
    categories = PhotoCategory.find(:all, :conditions => "active = 1 and category = " + PhotoCategory.category_by_name("Portraits").to_s)
    #Now add the categories' photo ids to the list
    session[:portrait_photo_ids] = []
    count = 0 #Keep track of the count to use for the random index
    categories.each do |cat|
      active_photo_ids = cat.active_photo_ids
      unless active_photo_ids.nil? || active_photo_ids.empty?
        count += active_photo_ids.size
        session[:portrait_photo_ids] += active_photo_ids
      end
    end
    if count > 0
      session[:portrait_index] = (Time.now.to_i % count)
    else
      session[:portrait_index] = count
    end
  end
  
  #Initialize the photo list for the client gallery page
  def initialize_client_gallery_page(shoot)
    session[:client_gallery] = shoot.photo_id_and_number_hash
    if session[:client_gallery].size > 0
      session[:client_gallery_index] = (Time.now.to_i % session[:client_gallery].size)
    else
      session[:client_gallery_index] = 0
    end
  end
end
