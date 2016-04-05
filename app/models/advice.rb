class Advice < ActiveRecord::Base
  
  validates :description, :type_advice,
  presence: true
end
