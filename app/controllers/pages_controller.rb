class PagesController < ApplicationController
  #before_action :must_login
  
  def index
    @date = DateTime.now.year
    @categories = Category.all
   
  end
 
end
