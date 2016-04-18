class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  before_action :show_user, only: [:index]

  # GET /meetings
  # GET /meetings.json
  def index
    
    #se for um usuario com perfil de administrador ele pode selecionar a agenda desejada por fucionario
    #ou exibir o agendamento de todos
    if params[:user_id].present?
    @meetings = Meeting.where(clerk_id: params[:user_id]).where('status != ?', 'COMPROU')
    elsif params[:user_id].blank?
    @meetings = Meeting.where('status != ?', 'COMPROU')
    end
    
    #se não tiver filtro e for um mero usuario é carregado somente os agendamentos dele
    if current_user.type_access == 'USER'
    @meetings = Meeting.where(clerk_id: current_user.id).where('status != ?', 'COMPROU')
    end
    
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = Meeting.new(meeting_params)
    #verifica se a data é anterior a data atual
    if @meeting.start_time.present? && @meeting.start_time < Date.today
      flash[:warning] = 'A data para agendamento não pode ser inferior a data atual, verifique os dados!'
      redirect_to new_meeting_path and return
    end
    
    #se marcar COMPROU é obrigatório informar o valor da venda
    if @meeting.status == 'COMPROU' && @meeting.cotation_value.blank?
      flash[:warning] = 'Não é possivel finalizar um atendimento onde ocorreu a compra sem informar o valor, verifique os dados!'
      redirect_to new_meeting_path and return
    end
            
     respond_to do |format|
      if @meeting.save
      #pegando o id que foi salvo pra montar o path do agendamento
       Meeting.update(@meeting.id, research_path: 'meetings' + '/' + @meeting.id.to_s, research_id: @meeting.id)
       
       if @meeting.status == 'COMPROU'
        flash[:success] = 'Parabens pelo excelente desempenho ' + current_user.name + '! ' + 'Este processo já foi finalizado com sucesso, e ai vamos para o próximo desafio?'
        redirect_to meetings_path and return
        else
        format.html { redirect_to @meeting, notice: 'Agendamento criado com sucesso.' }
        format.json { render :show, status: :created, location: @meeting }  
       end 
         
        
      else
        format.html { render :new }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    
    #se marcar COMPROU é obrigatório informar o valor da venda
    if meeting_params[:status] == 'COMPROU' && meeting_params[:cotation_value].blank?
    flash[:warning] = 'Não é possivel finalizar um atendimento onde ocorreu a compra sem informar o valor, verifique os dados!'
      redirect_to meeting_path(meeting_params) and return
    end
    
    respond_to do |format|
      if @meeting.update(meeting_params)
      
          #se comprou é direcionado para a agenda de compromissos
          if @meeting.status == 'COMPROU' && @meeting.cotation_value.present?
            flash[:success] = 'Parabens pelo excelente desempenho ' + current_user.name + '! ' + 'Este processo já foi finalizado com sucesso, e ai vamos para o próximo desafio?'
            redirect_to meetings_path and return
            else
            format.html { redirect_to @meeting, notice: 'Agendamento atualizado com sucesso.' }
          end
        format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting.destroy
    #tive que fazer essa query junto com o delete pra escluir com dois parametros
    Document.where(owner: @meeting).where(type_research: params[:request]).delete_all
    flash[:success] = 'Agendamento excluido com sucesso.'
      redirect_to meetings_url and return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_params
      params.require(:meeting).permit(:client, :phone, :status, :start_time, :clerk_id, :research_path, :research_id, :type_client, :obs, :cotation_value, :clerk_name)
    end
    
    def show_user
      @users = User.where('type_access != ?', 'MASTER').where('type_access != ?', 'ADMIN')
    end
end
