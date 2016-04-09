class Advice < ActiveRecord::Base
 
  # para poder permitir a exclusão da invoice mesmo tendo itens ou não
  has_many :solutions, dependent: :destroy
  
  validates :description, presence: true
end
