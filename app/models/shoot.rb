class Shoot < ActiveRecord::Base
  #Relationships
  belongs_to :gallery
  has_many :photos
  
  #Validations
  validates_presence_of :gallery_id, :shoot_name
  validates_uniqueness_of :shoot_name, :scope => :gallery_id
  
  def shoot_name_with_user
    if shoot_name.nil?
      return nil
    elsif gallery.nil? || gallery.user.nil? || gallery.user.username.nil?
      return shoot_name
    else
      return shoot_name + " (" + gallery.user.username + ")"
    end
  end
  
  #Return just the ids of the active photos in this shoot
  def photo_id_and_number_hash
    sql = ActiveRecord::Base.connection();
    sql.select_all("SELECT id, number FROM photos WHERE active = 1 AND shoot_id = " + id.to_s)
  end
end
