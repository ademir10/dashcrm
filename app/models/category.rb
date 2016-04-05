class Category < ActiveRecord::Base
  belongs_to :quiz
  
  validates :name, uniqueness: true
  validates :name,
  presence: true
end
