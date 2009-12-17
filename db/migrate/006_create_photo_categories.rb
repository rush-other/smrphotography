class CreatePhotoCategories < ActiveRecord::Migration
  #Create table
  def self.up
    create_table :photo_categories do |t|
      t.column :category, :integer, :null => false
      t.column :name, :string, :length => 100, :null => false
      t.column :active, :boolean, :null => false, :default => true
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
    end
    
    #Indexes
    add_index :photo_categories, :category
    add_index :photo_categories, :name, :unique => true
    
    PhotoCategory.create :category => 0, :name => "Portrait"
  end

  #Destroy table
  def self.down
    drop_table :photo_categories
  end
end
