class Photo < ActiveRecord::Base
  #Relationships
  belongs_to :shoot
  belongs_to :photo_category
  
  #Validations
  validates_presence_of :number, :shoot_id, :photo
  validates_uniqueness_of :number, :scope => :shoot_id
  
  #Set the number to the next available one
  def next_number
    if not shoot_id.nil?
      count = Photo.count_by_sql "SELECT COUNT(*) FROM photos WHERE active = 1 and shoot_id = " + shoot_id.to_s
      count + 1
    else
      nil
    end
  end
  
  def self.count_active
    Photo.count_by_sql "SELECT COUNT(*) FROM photos WHERE active = 1"
  end
  
  def self.find_ids(conditions)
    conditions = create_where_clause(conditions)
    sql = ActiveRecord::Base.connection();
    sql.select_values("SELECT id FROM photos" + conditions)
  end
  
  def self.find_paginated(conditions, order, page, limit)
    sql = "SELECT p.id as id, g.gallery_name as gallery_name, s.shoot_name as shoot_name, p.number as number"
    sql += " FROM photos p"
    sql += " INNER JOIN shoots s"
    sql += " ON p.shoot_id = s.id"
    sql += " INNER JOIN galleries g"
    sql += " ON s.gallery_id = g.id"
    sql += create_where_clause(conditions)
    unless order.nil?
      sql += " ORDER BY " + order
    end
    unless limit.nil?
      sql += " LIMIT " + limit.to_s
      unless page.nil? || page == 0
        sql += " OFFSET " + (page * limit).to_s
      end
    end
    puts sql
    connection = ActiveRecord::Base.connection();
    connection.select_all(sql)
  end

private
  def self.create_where_clause(conditions)
    if conditions.nil?
      conditions = ""
    else
      conditions = " WHERE " + conditions
    end
  end
end
