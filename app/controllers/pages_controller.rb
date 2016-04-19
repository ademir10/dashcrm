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
  #Relatório geral analitico por tipo de venda e data
  def analitics_report
    
    @users = User.where('type_access != ?', 'MASTER').order(:name)
    if params[:date1].blank?
      params[:date1] = Date.today
    end
    
    if params[:date2].blank?
      params[:date2] = Date.today
    end
    
    #se não informar nada, é carregado somentes as vendas do dia
    if params[:seller].blank? && params[:date1].blank? && params[:date2].blank?
      @meeting = Meeting.where(status: 'COMPROU').where("updated_at::Date = ?",Date.today).order(:updated_at)
      @total_meeting = Meeting.where(status: 'COMPROU').where("updated_at::Date ?",Date.today).sum(:cotation_value)
      
      @airsearch = Airsearch.where(status: 'COMPROU').where("updated_at::Date ?",Date.today).order(:updated_at)
      @total_airsearch = Airsearch.where(status: 'COMPROU').where("updated_at::Date ?",Date.today).sum(:cotation_value)
      
      @rodosearch = Rodosearch.where(status: 'COMPROU').where("updated_at::Date ?",Date.today).order(:updated_at)
      @total_rodosearch = Rodosearch.where(status: 'COMPROU').where("updated_at::Date ?",Date.today).sum(:cotation_value)

      
      @total_geral = @total_meeting.to_f + @total_airsearch.to_f + @total_rodosearch.to_f
      @total_geral = @total_geral.round(2)
    end
    
    #Se tiver informado somente as datas
    if params[:seller].blank? && params[:date1].present? && params[:date2].present?
      @meeting = Meeting.where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).order(:updated_at)
      @total_meeting = Meeting.where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).sum(:cotation_value)
      
      @airsearch = Airsearch.where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).order(:updated_at)
      @total_airsearch = Airsearch.where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).sum(:cotation_value)
      
      @rodosearch = Rodosearch.where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).order(:updated_at)
      @total_rodosearch = Rodosearch.where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).sum(:cotation_value)

      
      @total_geral = @total_meeting.to_f + @total_airsearch.to_f + @total_rodosearch.to_f 
      @total_geral = @total_geral.round(2)  
    end
    
    #Se tiver informado o funcionario e as datas
    if params[:seller].present? && params[:date1].present? && params[:date2].present?
      @meeting = Meeting.where(clerk_name: params[:seller]).where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).order(:updated_at)
      @total_meeting = Meeting.where(clerk_name: params[:seller]).where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).sum(:cotation_value)
      
      @airsearch = Airsearch.where(user: params[:seller]).where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).order(:updated_at)
      @total_airsearch = Airsearch.where(user: params[:seller]).where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).sum(:cotation_value)
      
      @rodosearch = Rodosearch.where(user: params[:seller]).where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).order(:updated_at)
      @total_rodosearch = Rodosearch.where(user: params[:seller]).where(status: 'COMPROU').where("updated_at::Date between ? and ?",params[:date1],params[:date2]).sum(:cotation_value)

      
      @total_geral = @total_meeting.to_f + @total_airsearch.to_f + @total_rodosearch.to_f
      @total_geral = @total_geral.round(2)
    end
  end
 
end
