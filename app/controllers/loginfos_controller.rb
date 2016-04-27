class LoginfosController < ApplicationController
  
  def index
        if params[:date1].blank?
      params[:date1] = Date.today
    end
    
    if params[:date2].blank?
      params[:date2] = Date.today
    end
    
    @logs = Loginfo.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(created_at: :desc)

  end
end
