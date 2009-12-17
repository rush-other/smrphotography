class CreateUsers < ActiveRecord::Migration
  #Create table
  def self.up
    create_table :users do |t|
      t.column :username, :string, :limit => 50, :null => false
      t.column :password, :string, :limit => 50
      t.column :role_id, :integer, :null => false
      t.column :active, :boolean, :null => false, :default => true
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
    end
    
    #Indexes
    add_index :users, :username, :unique => true
    add_index :users, :role_id
    
    #Default data
    User.create :username => 'jason', :password => 'trustno1', :role_id => 2
    User.create :username => 'shannon', :password => 'smr2470', :role_id => 2
  end
  
  #Destroy table
  def self.down
    drop_table :users
  end
end
