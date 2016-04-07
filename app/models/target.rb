class Target < ActiveRecord::Base
  belongs_to :advice
  
  validates :answer_id, presence: true
end
