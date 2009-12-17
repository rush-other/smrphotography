class CreatePhotos < ActiveRecord::Migration
  #Create table
  def self.up
    create_table :photos do |t|
      t.column :number, :integer, :null => false
      t.column :orig_file_name, :string, :length => 100, :null => false
      t.column :shoot_id, :integer, :null => false
      t.column :photo, :binary, :null => false, :limit => 1.gigabyte
      t.column :show_on_home, :boolean, :null => false, :default => false
      t.column :photo_category_id, :integer
      t.column :active, :boolean, :null => false, :default => true
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
    end
    
    #Indexes
    add_index :photos, :photo_category_id
    add_index :photos, :show_on_home
    add_index :photos, [:shoot_id, :number], :unique => true
  end

  #Destroy table
  def self.down
    drop_table :photos
  end
end
