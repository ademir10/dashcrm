class Category < ActiveRecord::Base
  belongs_to :quiz
  has_many :questions
  
  validates :name, uniqueness: true
  validates :name,
  presence: true
end
