class Role < ActiveRecord::Base
  #Validations
  validates_presence_of :name
  validates_uniqueness_of :name
end
