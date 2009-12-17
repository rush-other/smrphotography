class User < ActiveRecord::Base
  #Relationships
  belongs_to :role
  has_many :galleries
  
  #Validations
  validates_presence_of :username, :role_id
  validates_uniqueness_of :username
end
