class CreateNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscribers do |t|
      t.column :email, :string, :length => 255, :null => false
    end
    
    #Indexes
    add_index :newsletter_subscribers, :email, :unique => true
  end

  def self.down
    drop_table :newsletter_subscribers
  end
end
