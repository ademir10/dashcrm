class PagesController < ApplicationController
  #before_action :must_login
  
  def index
    @date = DateTime.now.year
    @categories = Category.order(:name)
  end
  
  #Relatório geral de rendimento dos funcionários separado por perquisa
  def business_report
    @datainicial = params[:date1]
    @datafinal = params[:date2]
    
  end
 
end
