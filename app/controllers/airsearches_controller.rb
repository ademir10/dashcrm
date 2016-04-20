class AirsearchesController < ApplicationController
  before_action :set_airsearch, only: [:show, :edit, :update, :destroy]
  before_action :show_question, only: [:show, :new, :edit, :update, :destroy]
  before_action :must_login
  
  #finaliza a prospecção da pesquisa alterando o status para FINALIZADA
  def end_research
   @airsearch = Airsearch.find(params[:id])
   
    #verifica se os campos foram preenchidos antes de finalizar a pesquisa
    if @airsearch.status.blank? || @airsearch.obs.blank? || @airsearch.reason.blank? || @airsearch.pains.blank? || @airsearch.solution_applied.blank? || @airsearch.cotation_value.blank?
      
      flash[:warning] = "Não é possivel finalizar uma pesquisa sem que todos os campos dela já estejam preenchidos e salvos, verifique se é realmente isso que você quer!"
      redirect_to airsearch_path(params[:id]) and return
    end
    
    Airsearch.update(params[:id], finished: 'SIM')
    
    #vai na agenda e exclui todos os agendamentos deste cliente
    Meeting.destroy.all(research_id: params[:id])
        
    flash[:success] = 'Parabens pelo excelente desempenho ' + current_user.name + '! ' + 'Este processo já foi finalizado com sucesso, e ai vamos para o próximo desafio?'
    redirect_to airsearches_path and return
    
  end
  
  #para atualizar os dados como o status, agendamento e inserir arquivos para upload
  def update_status_air
    
    @airsearch = Airsearch.find(params[:id])
    
    #é obrigatória a informação do status e valor cotado
    if airsearch_params[:status].blank? || airsearch_params[:cotation_value].blank?
      flash[:warning] = 'Em qualquer gerenciamento a informação do Valor cotado e o Status são obrigatórias, volte ao gerenciamento e atualize os dados!'
      redirect_to airsearch_path(@airsearch) and return
    end
    
    #se o cliente COMPROU
    if airsearch_params[:status] == 'COMPROU'
    
    Airsearch.update(params[:id], finished: 'SIM')
    
    #vai na agenda e exclui todos os agendamentos deste cliente
    Meeting.destroy_all(research_id: @airsearch)
    
    flash[:success] = 'Parabens pelo excelente desempenho ' + current_user.name + '! ' + 'Este processo já foi finalizado com sucesso, e ai vamos para o próximo desafio?'
    redirect_to airsearches_path and return  
    end
    
    #se o cliente está EM ANDAMENTO ele obrigatóriamente precisa fazer um agendamento caso não tenha feito ainda nenhum
    #com data posterior a data atual
    if airsearch_params[:status] == 'EM ANDAMENTO' && airsearch_params[:schedule].blank?
      check_meeting = Meeting.where(research_id: @airsearch).order("start_time DESC").first
      
      #se não tiver nenhum agendamento feito
      if check_meeting.blank?
        flash[:warning] = 'Você precisa informar uma data de agendamento para um próximo contato, não existe nenhum agendamento para este cliente.'
        redirect_to airsearch_path(@airsearch) and return
      end
      
      #se tiverem agendamentos somente com datas retroativas ao dia de hoje
      if check_meeting.present? && check_meeting.start_time.to_date <= Date.today
        flash[:warning] = 'Você precisa informar uma data de agendamento para um próximo contato, não existe nenhum agendamento com data posterior a hoje para este cliente.'
        redirect_to airsearch_path(@airsearch) and return
      end
    end
    
    if airsearch_params[:status].blank? && airsearch_params[:schedule].blank?
      flash[:warning] = 'Informe o Status e se for o caso uma data para agendamento!'
      redirect_to airsearch_path(@airsearch) and return
    elsif airsearch_params[:status] == 'NÃO COMPROU' && airsearch_params[:schedule].present?
      flash[:warning] = 'Você informou uma data para retorno e não informou o status corretamente, volte e atualize esta pesquisa!'
      redirect_to airsearch_path(@airsearch) and return
    end
        
    
    @airsearch.update(airsearch_params)
    
    #verifica se a data para um novo agendamento foi inserida
    #só faz o agendamento automático se a data for informada com uma data posterior a data atual
   if airsearch_params[:schedule].present? && airsearch_params[:schedule].to_date > Date.today
      airsearch = Airsearch.find(params[:id])
      meeting = Meeting.new(params[:meeting])
      meeting.name = airsearch.client
      meeting.cellphone = airsearch.phone
      meeting.start_time = airsearch_params[:schedule]
      meeting.clerk_id = current_user.id
      meeting.research_path = 'airsearches' + '/' + params[:id]
      meeting.research_id = params[:id]
      meeting.type_client = @airsearch.type_client
      meeting.save!
      flash[:success] = 'Os dados foram atualizados com sucesso e agendado um compromisso para o dia ' + airsearch_params[:schedule].to_time.strftime("%d/%m/%Y")
    elsif
    flash[:success] = 'Os dados foram atualizados com sucesso!' 
    end  
    #pego o id da pesquisa pra chamar a view
    id_airsearch = params[:id]  
    redirect_to airsearch_path(id_airsearch) and return
   
   
    
  end

  #gerenciamento da pesquisa
  def manage_air
  
  @result = Airsearch.find_by(id: params[:air_id])
  
  #apresenta sempre a data vazia para forçar o funcionário á fazer um novo agendamento nos casos de EM ANDAMENTO
  @result.schedule = nil 
 
  #se não tiver nada ainda cadastrado nas tratativas ai é forçado que o funcionário marque pelo menos uma opção
  if @result.solution_applied.blank?
  
    #primeiro verifica se foi selecionada pelo menos uma tratativa
    if params[:t1].blank? && params[:t2].blank? && params[:t3].blank? && params[:t4].blank? && params[:t5].blank? && params[:t6].blank? && params[:t7].blank? && params[:t8].blank? && params[:t9].blank? && params[:t10].blank?
      flash[:warning] = 'Você não selecionou nenhuma das tratativas propostas, selecione a(s) tratativa(s) adequada(s) para este cliente!'
      redirect_to airsearch_path(@result) and return
    end
        
        #concatenando as tratativas escolhidas para serem aplicadas
        if params[:t1].present?
        @solutions = params[:t1].to_s + "\n"
        end
        if params[:t2].present?
        @solutions = @solutions.to_s + params[:t2].to_s + "\n"
        end
        if params[:t3].present?
        @solutions = @solutions.to_s + params[:t3].to_s + "\n"
        end
        if params[:t4].present?
        @solutions = @solutions.to_s + params[:t4].to_s + "\n"
        end
        if params[:t5].present?
        @solutions = @solutions.to_s + params[:t5].to_s + "\n"
        end
        if params[:t6].present?
        @solutions = @solutions.to_s + params[:t6].to_s + "\n"
        end
        if params[:t7].present?
        @solutions = @solutions.to_s + params[:t7].to_s + "\n"
        end
        if params[:t8].present?
        @solutions = @solutions.to_s + params[:t8].to_s + "\n"
        end
        if params[:t9].present?
        @solutions = @solutions.to_s + params[:t9].to_s + "\n"
        end
        if params[:t10].present?
        @solutions = @solutions.to_s + params[:t10].to_s + "\n"
        end
      
      @result.solution_applied = @solutions
   end
  end

  def index
  if params[:tipo_consulta].blank?  
    @airsearches = Airsearch.order(:created_at, :client).where('finished = ?', 'NÃO').where(user_id: current_user.id).limit(50)
  else
    if params[:search] && params[:tipo_consulta] == "1"
          @airsearches = Airsearch.where("client like ?", "%#{params[:search]}%")
                                          
            elsif params[:search] && params[:tipo_consulta] == "2"
                @airsearches = Airsearch.where("phone like ?", "%#{params[:search]}%")
           
        end
    end
    
  end

  # GET /airsearches/1
  # GET /airsearches/1.json
  def show
    #carregando o cabeçalho, as perguntas e respostas
    @airsearches = Airsearch.where(id: params[:id])
    @q1 = Answer.find_by(id: @airsearch.q1)
    @q2 = Answer.find_by(id: @airsearch.q2)
    @q3 = Answer.find_by(id: @airsearch.q3)
    @q4 = Answer.find_by(id: @airsearch.q4)
    @q5 = Answer.find_by(id: @airsearch.q5)
    @q6 = Answer.find_by(id: @airsearch.q6)
    @q7 = Answer.find_by(id: @airsearch.q7)
    @q8 = Answer.find_by(id: @airsearch.q8)
    @q9 = Answer.find_by(id: @airsearch.q9)
    @q10 = Answer.find_by(id: @airsearch.q10)
    
    #faz o calculo do score pra saber se o cliente é quente, morno ou frio
    score1 = Answer.find_by(id: @airsearch.q1)
    score2 = Answer.find_by(id: @airsearch.q2)
    score3 = Answer.find_by(id: @airsearch.q3)
    score4 = Answer.find_by(id: @airsearch.q4)
    score5 = Answer.find_by(id: @airsearch.q5)
    score6 = Answer.find_by(id: @airsearch.q6)
    score7 = Answer.find_by(id: @airsearch.q7)
    score8 = Answer.find_by(id: @airsearch.q8)
    score9 = Answer.find_by(id: @airsearch.q9)
    score10 = Answer.find_by(id: @airsearch.q10)
    
    @total_score = score1.score.to_i + score2.score.to_i + score3.score.to_i + score4.score.to_i + score5.score.to_i + score6.score.to_i + score7.score.to_i + score8.score.to_i + score9.score.to_i + score10.score.to_i
    @total_score = @total_score / 10
    
    #exibe as tratativas
    @show_solution1 = Solution.find_by(answer_id: @q1)
    @show_solution2 = Solution.find_by(answer_id: @q2)
    @show_solution3 = Solution.find_by(answer_id: @q3)
    @show_solution4 = Solution.find_by(answer_id: @q4)
    @show_solution5 = Solution.find_by(answer_id: @q5)
    @show_solution6 = Solution.find_by(answer_id: @q6)
    @show_solution7 = Solution.find_by(answer_id: @q7)
    @show_solution8 = Solution.find_by(answer_id: @q8)
    @show_solution9 = Solution.find_by(answer_id: @q9)
    @show_solution10 = Solution.find_by(answer_id: @q10)
  end

  # GET /airsearches/new
  def new
    @airsearch = Airsearch.new
    
  end

  # GET /airsearches/1/edit
  def edit
  end

  # POST /airsearches
  # POST /airsearches.json
  def create
   @airsearch = Airsearch.new(airsearch_params)
   #verifica se todos os campos estão preenchidos
   if airsearch_params[:client].blank? || airsearch_params[:phone].blank? || airsearch_params[:q1].blank? || airsearch_params[:q2].blank? || airsearch_params[:q3].blank? || airsearch_params[:q4].blank? || airsearch_params[:q5].blank? || airsearch_params[:q6].blank? || airsearch_params[:q7].blank? || airsearch_params[:q8].blank? || airsearch_params[:q9].blank? || airsearch_params[:q10].blank?
     flash[:warning] = 'Os dados do cliente e todas as perguntas precisam ser respondidas!'
     redirect_to new_airsearch_path and return
   end
    
    respond_to do |format|
      @airsearch.user_id = current_user.id
      @airsearch.user = current_user.name
      @airsearch.status = 'NÃO DEFINIDO'
      @airsearch.finished = 'NÃO'
      
      if @airsearch.save
        
        #faz o calculo do score pra atualizar o tipo de cliente na tabela
        score1 = Answer.find_by(id: airsearch_params[:q1])
        score2 = Answer.find_by(id: airsearch_params[:q2])
        score3 = Answer.find_by(id: airsearch_params[:q3])
        score4 = Answer.find_by(id: airsearch_params[:q4])
        score5 = Answer.find_by(id: airsearch_params[:q5])
        score6 = Answer.find_by(id: airsearch_params[:q6])
        score7 = Answer.find_by(id: airsearch_params[:q7])
        score8 = Answer.find_by(id: airsearch_params[:q8])
        score9 = Answer.find_by(id: airsearch_params[:q9])
        score10 = Answer.find_by(id: airsearch_params[:q10])
        
        @total_score = score1.score.to_i + score2.score.to_i + score3.score.to_i + score4.score.to_i + score5.score.to_i + score6.score.to_i + score7.score.to_i + score8.score.to_i + score9.score.to_i + score10.score.to_i
        @total_score = @total_score / 10
        
        check_score = Airsearch.find_by(id: @airsearch)
              
              if @total_score > 0 && @total_score <= 2
              check_score.update_attributes(type_client: 'FRIO')
              elsif @total_score >= 3 && @total_score <= 6
              check_score.update_attributes(type_client: 'MORNO') 
              elsif @total_score >= 7 && @total_score <= 10 
              check_score.update_attributes(type_client: 'QUENTE')
              end  
        
        
        
        
        
        #cadastrando automáticamente esse cliente pesquisado no cadastro de clientes
        client = Client.new(params[:client])
        client.name = airsearch_params[:client]
        client.cellphone = airsearch_params[:phone]
        client.save!
                      
        format.html { redirect_to @airsearch, notice: 'Questionário criado com sucesso.' }
        format.json { render :show, status: :created, location: @airsearch }
      else
        format.html { render :new }
        format.json { render json: @airsearch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /airsearches/1
  # PATCH/PUT /airsearches/1.json
  def update
    
    if airsearch_params[:client].blank? || airsearch_params[:phone].blank?
     flash[:warning] = 'Informe o nome e Celular do cliente!'
     redirect_to edit_airsearch_path(@airsearch) and return
    end
    
    respond_to do |format|
      if @airsearch.update(airsearch_params)
        
        #faz o calculo do score pra atualizar o tipo de cliente na tabela
        score1 = Answer.find_by(id: airsearch_params[:q1])
        score2 = Answer.find_by(id: airsearch_params[:q2])
        score3 = Answer.find_by(id: airsearch_params[:q3])
        score4 = Answer.find_by(id: airsearch_params[:q4])
        score5 = Answer.find_by(id: airsearch_params[:q5])
        score6 = Answer.find_by(id: airsearch_params[:q6])
        score7 = Answer.find_by(id: airsearch_params[:q7])
        score8 = Answer.find_by(id: airsearch_params[:q8])
        score9 = Answer.find_by(id: airsearch_params[:q9])
        score10 = Answer.find_by(id: airsearch_params[:q10])
        
        @total_score = score1.score.to_i + score2.score.to_i + score3.score.to_i + score4.score.to_i + score5.score.to_i + score6.score.to_i + score7.score.to_i + score8.score.to_i + score9.score.to_i + score10.score.to_i
        @total_score = @total_score / 10
        
        check_score = Airsearch.find_by(id: @airsearch)
              
              if @total_score > 0 && @total_score <= 2
              check_score.update_attributes(type_client: 'FRIO')
              elsif @total_score >= 3 && @total_score <= 6
              check_score.update_attributes(type_client: 'MORNO') 
              elsif @total_score >= 7 && @total_score <= 10 
              check_score.update_attributes(type_client: 'QUENTE')
              end  
        
        
        
        format.html { redirect_to @airsearch, notice: 'Questionário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @airsearch }
      else
        format.html { render :edit }
        format.json { render json: @airsearch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /airsearches/1
  # DELETE /airsearches/1.json
  def destroy
    @airsearch.destroy
    Document.destroy_all(owner: @airsearch)
    Meeting.destroy_all(research_id: @airsearch)
    respond_to do |format|
      format.html { redirect_to airsearches_url, notice: 'Questionário Excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_airsearch
      @airsearch = Airsearch.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def airsearch_params
      params.require(:airsearch).permit(:user, :client, :phone, :q1, :q2, :q3, :q4, :q5, :q6, :q7, :q8, :q9, :q10, :status, :obs, :schedule, :reason, :pains, :solution_applied, :cotation_value, :finished, :user_id)
    end
    
    def show_question
      
      @question1 = Question.find_by(id: '1')
      @question2 = Question.find_by(id: '2')
      @question3 = Question.find_by(id: '3')
      @question4 = Question.find_by(id: '4')
      @question5 = Question.find_by(id: '5')
      @question6 = Question.find_by(id: '6')
      @question7 = Question.find_by(id: '7')
      @question8 = Question.find_by(id: '8')
      @question9 = Question.find_by(id: '9')
      @question10 = Question.find_by(id: '10')
      
      
      if @question1.blank? || @question2.blank? || @question3.blank? || @question4.blank? || @question5.blank? || @question6.blank? || @question7.blank? || @question8.blank? || @question9.blank? || @question10.blank?
      flash[:warning] = "Você precisa cadastrar primeiro as 10 perguntas e respostas com as tratativas para esta pesquisa!"
      redirect_to questions_path and return
      end  
           
    end
    
end
