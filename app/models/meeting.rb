class Meeting < ActiveRecord::Base
  
  validates :name, :cellphone, :start_time, :status, :type_client, presence: true
end
