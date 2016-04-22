class LoginfosController < ApplicationController
  
  def index
    @logs = Loginfo.all
  end
end
