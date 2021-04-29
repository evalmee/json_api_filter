class User < ApplicationRecord
  
  has_many :posts
  has_many :articles, class_name: 'Post', foreign_key: "user_id"

  def self.fake_global_search(value)
    where("name = ?", value)
  end
  
  def self.fake_name_search(value)
    where("name = ?", value)
  end

end
