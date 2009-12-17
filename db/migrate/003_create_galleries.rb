class CreateGalleries < ActiveRecord::Migration
  #Create table
  def self.up
    create_table :galleries do |t|
      t.column :user_id, :integer, :null => false
      t.column :gallery_name, :string, :length => 100, :null => false
      t.column :context, :string, :length => 50
      t.column :password, :string, :length => 50
      t.column :active, :boolean, :null => false, :default => true
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
    end
    
    #Indexes
    add_index :galleries, :user_id
    add_index :galleries, :gallery_name, :unique => true
    add_index :galleries, :context, :unique => true
    
  end
  
  #Destroy table
  def self.down
    drop_table :galleries
  end
end
