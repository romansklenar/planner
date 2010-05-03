class Tasklist < ActiveRecord::Base
  attr_accessible :name, :type, :description, :user_id
end
