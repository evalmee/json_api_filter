class User < ApplicationRecord

  def self.fake_global_search(value)
    where("name = ?", value)
  end
  
  def self.fake_name_search(value)
    where("name = ?", value)
  end

end
