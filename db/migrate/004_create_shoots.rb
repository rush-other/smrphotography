class CreateShoots < ActiveRecord::Migration
  #Create table
  def self.up
    create_table :shoots do |t|
      t.column :gallery_id, :integer, :null => false
      t.column :shoot_name, :string, :length => 100, :null => false
      t.column :active, :boolean, :null => false, :default => true
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
    end
    
    #Indexes
    add_index :shoots, [:gallery_id, :shoot_name], :unique => true
    
  end

  #Destroy table
  def self.down
    drop_table :shoots
  end
end
