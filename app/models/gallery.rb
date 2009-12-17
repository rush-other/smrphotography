class Gallery < ActiveRecord::Base
  #Relationships
  belongs_to :user
  has_many :shoots
  
  #Validations
  validates_presence_of :user_id, :gallery_name
  validates_uniqueness_of :gallery_name
  validates_uniqueness_of :context
  
  #Find a record by the context of the gallery
  def self.find_by_context(query)
    return nil if query.blank?
    find(:first, :conditions => "active = 1 and context = '" + query + "'")
  end
end
