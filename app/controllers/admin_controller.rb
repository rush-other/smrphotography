class AdminController < ApplicationController
  layout 'admin_frame'
  
  PAGE_COUNT = 25
  #PHOTO
  #log
  def photo_log
    total = Photo.count_active
    @page_count = (total.to_f / PAGE_COUNT.to_f).ceil
    if params[:page].blank?
      @page = 0
    else
      #Page is 0-based, but URL param is 1 based for readability
      @page = params[:page].to_i - 1
    end
    @page = 0 if @page >= @page_count
    @photos = Photo.find_paginated("p.active = 1", "p.shoot_id, p.number", @page, PAGE_COUNT)
  end
  #edit form
  def photo_edit
    @shoots = Shoot.find(:all, :conditions => "active = 1")
    @photo_categories = PhotoCategory.find(:all, :conditions => "active = 1")
    if params[:id].blank?
      #This is for a new user
      @photo = Photo.new
      @url_action = "photo_create"
    else
      #This is for an edit
      @photo = Photo.find(params[:id])
      @url_action = "photo_update"
    end
  end
  #partial for the upload components
  def add_upload_component
    render_partial "upload_components"
  end
  #update action
  def photo_update
    #This is for an edit
    photo = Photo.find(params[:id])
    #Make sure this is a valid user
    if photo.nil?
      flash[:messages] = ["Invalid photo with ID " + params[:id]]
      redirect_to :action => "photo_log"
      return
    end
    #Get the photo and file name before saving the other attributes
    params[:photo][:orig_file_name] = params[:temp_photo].original_filename.gsub(/[^a-zA-Z0-9.]/, '_')
    params[:photo][:photo] = params[:temp_photo].read
    #Delete the temp photo
    #Save the remaining attributes
    if photo.update_attributes(params[:photo])
      flash[:messages] = ["Saved photo " + photo.number.to_s]
      redirect_to :action => 'photo_log'
    else
      flash[:messages] = photo.errors
      redirect_to :action => 'photo_edit', :id => params[:id]
    end
  end
  #create action
  def photo_create
    #Initialize the messages array
    flash[:messages] = []
    at_least_one = false  #Flag to determine if at least one photo was uploaded
    go_to_log = false
    #Iterate through each of the 10 possible uploads
    10.times do |i|
      if not params["temp_photo" + i.to_s].blank?
        temp_file = params["temp_photo" + i.to_s]
        #Make sure it is not an empty file
        if temp_file.length != 0
          at_least_one = true
          photo = Photo.new(params[:photo])
          photo.orig_file_name = temp_file.original_filename.gsub(/[^a-zA-Z0-9.]/, '_')
          photo.photo = temp_file.read
          photo.show_on_home = params["show_on_home" + i.to_s]
          photo.show_on_home = false if photo.show_on_home.nil?
          photo.number = photo.next_number 
          if photo.save
            flash[:messages] << "Saved photo " + photo.number.to_s
            go_to_log = true
          else
            flash[:messages] += photo.errors.to_a
          end
        end
      end
    end
    if not at_least_one
      flash[:messages] << "No photos uploaded..."
    end
    if go_to_log
      redirect_to :action => 'photo_log'
    else
      redirect_to :action => 'photo_edit'
    end
  end
  #delete action
  def photo_del
    if not params[:id].blank?
      photo = Photo.find(params[:id])
      if not photo.nil?
        photo_name = photo.number
        photo.active = false
        if photo.save
          flash[:messages] = ["Deleted photo " + photo_name]
        else
          flash[:messages] = ["Unable to delete photo " + photo_name]
        end
      else
        flash[:messages] = ["Unable to find photo with ID " + params[:id]]
      end
    else
      flash[:messages] = ["No photo ID provided for deletion"]
    end
    redirect_to :action => 'photo_log'
  end
  
  #GALLERY
  #log
  def gallery_log
    @galleries = Gallery.find(:all, :conditions => "active = 1")
  end
  #edit form
  def gallery_edit
    @users = User.find(:all, :conditions => "active = 1")
    if params[:id].blank?
      #This is for a new user
      @gallery = Gallery.new
    else
      #This is for an edit
      @gallery = Gallery.find(params[:id])
    end
  end
  #update/create action
  def gallery_update_or_create
    if params[:id].blank?
      #This is for a new gallery
      gallery = Gallery.new
    else
      #This is for an edit
      gallery = Gallery.find(params[:id])
      #Make sure this is a valid user
      if gallery.nil?
        flash[:messages] = ["Invalid gallery with ID " + params[:id]]
        redirect_to :action => "gallery_log"
        return
      end
    end
    #Check the URL context for .html and strip it
    params[:gallery][:context].gsub!(/.html/, '')
    if gallery.update_attributes(params[:gallery])
      flash[:messages] = ["Saved gallery " + gallery.gallery_name]
      redirect_to :action => 'gallery_log'
    else
      flash[:messages] = gallery.errors
      redirect_to :action => 'gallery_edit', :id => params[:id]
    end
  end
  #delete action
  def gallery_del
    if not params[:id].blank?
      gallery = Gallery.find(params[:id])
      if not gallery.nil?
        gallery_name = gallery.gallery_name
        gallery.active = false
        if gallery.save
          flash[:messages] = ["Deleted gallery " + gallery_name]
        else
          flash[:messages] = ["Unable to delete gallery " + gallery_name]
        end
      else
        flash[:messages] = ["Unable to find gallery with ID " + params[:id]]
      end
    else
      flash[:messages] = ["No gallery ID provided for deletion"]
    end
    redirect_to :action => 'gallery_log'
  end
  
  #PHOTO CATEGORY
  #log
  def photo_category_log
    @photo_categories = PhotoCategory.find(:all, :conditions => "active = 1")
  end
  #edit form
  def photo_category_edit
    if params[:id].blank?
      #This is for a new user
      @photo_category = PhotoCategory.new
    else
      #This is for an edit
      @photo_category = PhotoCategory.find(params[:id])
    end
  end
  #update/create action
  def photo_category_update_or_create
    if params[:id].blank?
      #This is for a new gallery
      pc = PhotoCategory.new
    else
      #This is for an edit
      pc = PhotoCategory.find(params[:id])
      #Make sure this is a valid user
      if pc.nil?
        flash[:messages] = ["Invalid photo category with ID " + params[:id]]
        redirect_to :action => "photo_category_log"
        return
      end
    end
    if pc.update_attributes(params[:photo_category])
      flash[:messages] = ["Saved photo category " + pc.name]
      redirect_to :action => 'photo_category_log'
    else
      flash[:messages] = pc.errors
      redirect_to :action => 'photo_category_edit', :id => params[:id]
    end
  end
  #delete action
  def photo_category_del
    if not params[:id].blank?
      pc = PhotoCategory.find(params[:id])
      if not pc.nil?
        name = pc.name
        pc.active = false
        if pc.save
          flash[:messages] = ["Deleted photo category " + name]
        else
          flash[:messages] = ["Unable to delete photo category " + name]
        end
      else
        flash[:messages] = ["Unable to find photo category with ID " + params[:id]]
      end
    else
      flash[:messages] = ["No photo category ID provided for deletion"]
    end
    redirect_to :action => 'photo_category_log'
  end
  
  #SHOOT
  #log
  def shoot_log
    @shoots = Shoot.find(:all, :conditions => "active = 1")
  end
  #edit form
  def shoot_edit
    @galleries = Gallery.find(:all, :conditions => "active = 1")
    if params[:id].blank?
      #This is for a new user
      @shoot = Shoot.new
    else
      #This is for an edit
      @shoot = Shoot.find(params[:id])
    end
  end
  #update/create action
  def shoot_update_or_create
    if params[:id].blank?
      #This is for a new gallery
      shoot = Shoot.new
    else
      #This is for an edit
      shoot = Shoot.find(params[:id])
      #Make sure this is a valid user
      if shoot.nil?
        flash[:messages] = ["Invalid shoot with ID " + params[:id]]
        redirect_to :action => "shoot_log"
        return
      end
    end
    if shoot.update_attributes(params[:shoot])
      flash[:messages] = ["Saved shoot " + shoot.shoot_name]
      redirect_to :action => 'shoot_log'
    else
      flash[:messages] = shoot.errors
      redirect_to :action => 'shoot_edit', :id => params[:id]
    end
  end
  #delete action
  def shoot_del
    if not params[:id].blank?
      shoot = Shoot.find(params[:id])
      if not shoot.nil?
        shoot_name = shoot.shoot_name
        shoot.active = false
        if shoot.save
          flash[:messages] = ["Deleted shoot " + shoot_name]
        else
          flash[:messages] = ["Unable to delete shoot " + shoot_name]
        end
      else
        flash[:messages] = ["Unable to find shoot with ID " + params[:id]]
      end
    else
      flash[:messages] = ["No shoot ID provided for deletion"]
    end
    redirect_to :action => 'shoot_log'
  end
  
  #USER
  #log
  def user_log
    @users = User.find(:all, :conditions => "active = 1")
  end
  #edit form
  def user_edit
    @roles = Role.find(:all)
    if params[:id].blank?
      #This is for a new user
      @user = User.new
    else
      #This is for an edit
      @user = User.find(params[:id])
    end
  end
  #update/create action
  def user_update_or_create
    if params[:id].blank?
      #This is for a new user
      user = User.new
    else
      #This is for an edit
      user = User.find(params[:id])
      #Make sure this is a valid user
      if user.nil?
        flash[:messages] = ["Invalid user with ID " + params[:id]]
        redirect_to :action => "user_log"
        return
      end
    end
    if user.update_attributes(params[:user])
      flash[:messages] = ["Saved user " + user.username]
      redirect_to :action => 'user_log'
    else
      flash[:messages] = user.errors
      redirect_to :action => 'user_edit', :id => params[:id]
    end
  end
  #delete action
  def user_del
    if not params[:id].blank?
      user = User.find(params[:id])
      if not user.nil?
        username = user.username
        user.active = false
        if user.save
          flash[:messages] = ["Deleted user " + username]
        else
          flash[:messages] = ["Unable to delete user " + username]
        end
      else
        flash[:messages] = ["Unable to find user with ID " + params[:id]]
      end
    else
      flash[:messages] = ["No user ID provided for deletion"]
    end
    redirect_to :action => 'user_log'
  end
  
private
  def required_role
    ROLE_ADMIN
  end
end
