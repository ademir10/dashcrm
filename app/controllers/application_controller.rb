class ApplicationController < ActionController::Base
   # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  def current_user
    
    #calculando o total de pesquisas já feitas do dia
    @qnt_rodo = Rodosearch.where("created_at::date = ?", Date.today).where(user_id: session[:user_id]).where(finished: 'SIM').count
    @qnt_air = Airsearch.where("created_at::date = ?", Date.today).where(user_id: session[:user_id]).where(finished: 'SIM').count
    @qnt_pack = Packsearch.where("created_at::date = ?", Date.today).where(user_id: session[:user_id]).where(finished: 'SIM').count
    @qnt_meeting = Meeting.where("created_at::date = ?", Date.today).where(clerk_id: session[:user_id]).where(status: 'COMPROU').count
    @total_qnt = @qnt_rodo.to_i + @qnt_air.to_i + @qnt_pack.to_i + @qnt_meeting.to_i
       
    #calcula os totais por categoria de pesquisa com base no usuário logado
    @total_rodo = Rodosearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: session[:user_id]).where(finished: 'SIM').sum(:cotation_value)
    @total_air = Airsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: session[:user_id]).where(finished: 'SIM').sum(:cotation_value)
    @total_pack = Packsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: session[:user_id]).where(finished: 'SIM').sum(:cotation_value)
    @total_meeting = Meeting.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(clerk_id: session[:user_id]).where(status: 'COMPROU').sum(:cotation_value)
    @total_research = @total_rodo.to_f + @total_air.to_f + @total_pack.to_f + @total_meeting.to_f
    @total_research = @total_research.round(2)
    @goal = session[:goal]
    
    #calcula o percentual já vendido
    @current_goal = (@total_research.to_f / @goal.to_f) * 100
    
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    
    
  end
  
  def logged_in?
    !!current_user
  end
  
  def must_login
    if !logged_in?
      flash[:danger] = "Você ainda não esta logado, efetue o login."
      redirect_to login_path
    end
  end
  
  #USADO PARA NÃO DEIXAR DAR O ERRO DE RELACIONAMENTO ENTRE TABELAS
  rescue_from 'ActiveRecord::InvalidForeignKey' do
  redirect_to message_error_relation_tables_path
  end
end
