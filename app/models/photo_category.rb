class PhotoCategory < ActiveRecord::Base
  #Relationships
  has_many :photos
  
  #Validations
  validates_uniqueness_of :name
  validates_presence_of :name, :category
  
  def category_name
    PhotoCategory.CATEGORY_OPTIONS.each do |opt|
      if category == opt[:id]
        return opt[:name]
      end
    end
    return nil
  end
  
  def category_name=(name)
    PhotoCategory.CATEGORY_OPTIONS.each do |opt|
      if name == opt[:name]
        category = opt[:id]
      end
      category = nil
    end
  end
  
  #Return just the ids of the active photos in this category
  def active_photo_ids
    sql = ActiveRecord::Base.connection();
    sql.select_values("SELECT id FROM photos WHERE active = 1 AND photo_category_id = " + id.to_s)
  end
  
  #CLASS METHODS
  def self.CATEGORY_OPTIONS
    [{:id => 0, :name => "Portraits"}, {:id => 1, :name => "Events"}]
  end
  
  def self.category_by_name(name)
    PhotoCategory.CATEGORY_OPTIONS.each do |opt|
      if name == opt[:name]
        return opt[:id]
      end
    end
    return nil
  end
end
