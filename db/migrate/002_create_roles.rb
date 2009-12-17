class CreateRoles < ActiveRecord::Migration
  #Create table
  def self.up
    create_table :roles do |t|
      t.column :name, :string, :length => 50, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
    end
    
    #Indexes
    add_index :roles, :name, :unique => true
    
    #Add default data
    Role.create :name => 'client'
    Role.create :name => 'admin'
  end
  
  #Destroy table
  def self.down
    drop_table :roles
  end
end
