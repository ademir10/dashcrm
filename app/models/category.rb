class Category < ActiveRecord::Base
  belongs_to :quiz
  
  validates :name, :link, uniqueness: true
  validates :name,
  presence: true
end
