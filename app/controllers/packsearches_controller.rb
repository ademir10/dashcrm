class PacksearchesController < ApplicationController
  before_action :set_packsearch, only: [:show, :edit, :update, :destroy]
  before_action :show_question, only: [:show, :new, :edit, :update, :destroy]
  before_action :show_user, only: [:new, :edit]
  before_action :must_login
    
  #para atualizar os dados como o status, agendamento e inserir arquivos para upload
  def update_status_pack
    
    @packsearch = Packsearch.find(params[:id])
    
    #é obrigatória a informação do status e valor cotado
    if packsearch_params[:status].blank? || packsearch_params[:cotation_value].blank?
      flash[:warning] = 'Em qualquer gerenciamento a informação do Valor cotado e o Status são obrigatórias, volte ao gerenciamento e atualize os dados!'
      redirect_to packsearch_path(@packsearch) and return
    end
    
    #se o cliente COMPROU
    if packsearch_params[:status] == 'COMPROU'
    
    Packsearch.update(params[:id],status: 'COMPROU', finished: 'SIM')
              
    #vai na agenda e exclui todos os agendamentos deste cliente
    Meeting.destroy_all(research_id: @packsearch)
    
       #ESTE BLOCO DE CODE É UTILIZADO PARA ATUALIZAR AS METAS DO USUÁRIO SEMPRE QUE CRIAR/ATUALIZAR/DELETAR PESQUISA
        #calculando o total de agendamentos do dia
        @total_qnt = Meeting.where(start_time: Date.today).where(clerk_id: current_user.id).where(status: 'EM ANDAMENTO').count

                  
        #calcula os totais por categoria de pesquisa com base no usuário logado
        @total_rodo = Rodosearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_air = Airsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_pack = Packsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_meeting = Meeting.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(clerk_id: current_user.id).where(status: 'COMPROU').sum(:cotation_value)
        @total_research = @total_rodo.to_f + @total_air.to_f + @total_pack.to_f + @total_meeting.to_f
        @total_research = @total_research.round(2)
        #calcula o percentual já vendido
        @current_goal = (@total_research.to_f / current_user.goal.to_f) * 100
        @current_goal = @current_goal.round(2)
        
        #atualiza os dados de meta mensal do usuário
        User.update(current_user.id, qnt_research: @total_qnt.to_i, total_sale: @total_research, current_percent: @current_goal.to_f)
     #-----------------------------------FIM DO BLOCO-------------------------------------------------------------
    
        #COMPROU
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Finalizou compra de pesquisa - Pacote de Viagem / Cliente ' + @packsearch.client.to_s
        log.save!
    
    flash[:success] = 'Parabens pelo excelente desempenho ' + current_user.name + '! ' + 'Este processo já foi finalizado com sucesso, e ai vamos para o próximo desafio?'
    redirect_to meetings_path and return  
    end
    
    #se o cliente está EM ANDAMENTO ele obrigatóriamente precisa fazer um agendamento caso não tenha feito ainda nenhum
    #com data posterior a data atual
    if packsearch_params[:status] == 'EM ANDAMENTO' && packsearch_params[:schedule].blank?
      check_meeting = Meeting.where(research_id: @packsearch).where("research_path LIKE ?", "%#{'packsearch'}%").order("start_time DESC").first
      
      #se não tiver nenhum agendamento feito
      if check_meeting.blank?
        flash[:warning] = 'Você precisa informar uma data de agendamento para um próximo contato, não existe nenhum agendamento para este cliente.'
        redirect_to packsearch_path(@packsearch) and return
      end
      
      #se tiverem agendamentos somente com datas retroativas ao dia de hoje
      if check_meeting.present? && check_meeting.start_time.to_date <= Date.today
        flash[:warning] = 'Você precisa informar uma data de agendamento para um próximo contato, não existe nenhum agendamento com data posterior a hoje para este cliente.'
        redirect_to packsearch_path(@packsearch) and return
      end
    end
    
    if packsearch_params[:status].blank? && packsearch_params[:schedule].blank?
      flash[:warning] = 'Informe o Status e se for o caso uma data para agendamento!'
      redirect_to packsearch_path(@packsearch) and return
    end
        
    @packsearch.update(packsearch_params)
    
        #ESTE BLOCO DE CODE É UTILIZADO PARA ATUALIZAR AS METAS DO USUÁRIO SEMPRE QUE CRIAR/ATUALIZAR/DELETAR PESQUISA
        #calculando o total de agendamentos do dia
        @total_qnt = Meeting.where(start_time: Date.today).where(clerk_id: current_user.id).where(status: 'EM ANDAMENTO').count

                  
        #calcula os totais por categoria de pesquisa com base no usuário logado
        @total_rodo = Rodosearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_air = Airsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_pack = Packsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_meeting = Meeting.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(clerk_id: current_user.id).where(status: 'COMPROU').sum(:cotation_value)
        @total_research = @total_rodo.to_f + @total_air.to_f + @total_pack.to_f + @total_meeting.to_f
        @total_research = @total_research.round(2)
        #calcula o percentual já vendido
        @current_goal = (@total_research.to_f / current_user.goal.to_f) * 100
        @current_goal = @current_goal.round(2)
        
        #atualiza os dados de meta mensal do usuário
        User.update(current_user.id, qnt_research: @total_qnt.to_i, total_sale: @total_research, current_percent: @current_goal.to_f)
     #-----------------------------------FIM DO BLOCO-------------------------------------------------------------
    
    #verifica se a data para um novo agendamento foi inserida
    #só faz o agendamento automático se a data for informada com uma data posterior a data atual
   if packsearch_params[:schedule].present? && packsearch_params[:schedule].to_date > Date.today
      packsearch = Packsearch.find(params[:id])
      meeting = Meeting.new(params[:meeting])
      meeting.client = packsearch.client
      meeting.phone = packsearch.phone
      meeting.cotation_value = packsearch.cotation_value
      meeting.status = packsearch.status
      meeting.type_client = packsearch.type_client
      meeting.start_time = packsearch_params[:schedule]
      meeting.clerk_id = current_user.id
      meeting.research_path = 'packsearches' + '/' + params[:id]
      meeting.research_id = params[:id]
      meeting.type_client = @packsearch.type_client
      meeting.save!
      
      
        #AGENDAMENTO
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Gerenciou pesquisa - Pacote de Viagem com agendamento para ' + packsearch_params[:schedule].to_time.strftime("%d/%m/%Y") + ' / Cliente ' + @packsearch.client.to_s
        log.save!
      flash[:success] = 'Os dados foram atualizados com sucesso e agendado um compromisso para o dia ' + packsearch_params[:schedule].to_time.strftime("%d/%m/%Y")
    elsif
      
        #ATUALIZOU DADOS
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Gerenciou pesquisa atualizando dados - Pacote de Viagem / Cliente ' + @packsearch.client.to_s
        log.save!
        
    flash[:success] = 'Os dados foram atualizados com sucesso!' 
    end  
    #pego o id da pesquisa pra chamar a view
    id_packsearch = params[:id]  
    redirect_to packsearch_path(id_packsearch) and return
   
   
    
  end

  #gerenciamento da pesquisa
  def manage_pack
  
  @result = Packsearch.find_by(id: params[:pack_id])
  
  #apresenta sempre a data vazia para forçar o funcionário á fazer um novo agendamento nos casos de EM ANDAMENTO
  @result.schedule = nil 
 
  #se não tiver nada ainda cadastrado nas tratativas ai é forçado que o funcionário marque pelo menos uma opção
  if @result.solution_applied.blank?
  
    #primeiro verifica se foi selecionada pelo menos uma tratativa
    if params[:t1].blank? && params[:t2].blank? && params[:t3].blank? && params[:t4].blank? && params[:t5].blank? && params[:t6].blank? && params[:t7].blank? && params[:t8].blank? && params[:t9].blank? && params[:t10].blank? && params[:t11].blank? && params[:t12].blank? && params[:t13].blank?
      flash[:warning] = 'Você não selecionou nenhuma das tratativas propostas, selecione a(s) tratativa(s) adequada(s) para este cliente!'
      redirect_to packsearch_path(@result) and return
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
        if params[:t11].present?
        @solutions = @solutions.to_s + params[:t11].to_s + "\n"
        end
        if params[:t12].present?
        @solutions = @solutions.to_s + params[:t12].to_s + "\n"
        end
        if params[:t13].present?
        @solutions = @solutions.to_s + params[:t13].to_s + "\n"
        end
      
      @result.solution_applied = @solutions
   end
  end

  def index
  if params[:tipo_consulta].blank?  
    @packsearches = Packsearch.order(:created_at, :client).where('finished = ?', 'NÃO').where(user_id: current_user.id).limit(50)
  else
    if params[:search] && params[:tipo_consulta] == "1"
          @packsearches = Packsearch.where("client like ?", "%#{params[:search]}%")
                                          
            elsif params[:search] && params[:tipo_consulta] == "2"
                @packsearches = Packsearch.where("phone like ?", "%#{params[:search]}%")
           
        end
    end
    
  end

  # GET /packsearches/1
  # GET /packsearches/1.json
  def show
    #carregando o cabeçalho, as perguntas e respostas
    @packsearches = Packsearch.where(id: params[:id])
    @q1 = Answer.find_by(id: @packsearch.q1)
    @q2 = Answer.find_by(id: @packsearch.q2)
    @q3 = Answer.find_by(id: @packsearch.q3)
    @q4 = Answer.find_by(id: @packsearch.q4)
    @q5 = Answer.find_by(id: @packsearch.q5)
    @q6 = Answer.find_by(id: @packsearch.q6)
    @q7 = Answer.find_by(id: @packsearch.q7)
    @q8 = Answer.find_by(id: @packsearch.q8)
    @q9 = Answer.find_by(id: @packsearch.q9)
    @q10 = Answer.find_by(id: @packsearch.q10)
    @q11 = Answer.find_by(id: @packsearch.q11)
    @q12 = Answer.find_by(id: @packsearch.q12)
    @q13 = Answer.find_by(id: @packsearch.q13)
    
    #faz o calculo do score pra saber se o cliente é quente, morno ou frio
    score1 = Answer.find_by(id: @packsearch.q1)
    score2 = Answer.find_by(id: @packsearch.q2)
    score3 = Answer.find_by(id: @packsearch.q3)
    score4 = Answer.find_by(id: @packsearch.q4)
    score5 = Answer.find_by(id: @packsearch.q5)
    score6 = Answer.find_by(id: @packsearch.q6)
    score7 = Answer.find_by(id: @packsearch.q7)
    score8 = Answer.find_by(id: @packsearch.q8)
    score9 = Answer.find_by(id: @packsearch.q9)
    score10 = Answer.find_by(id: @packsearch.q10)
    score11 = Answer.find_by(id: @packsearch.q11)
    score12 = Answer.find_by(id: @packsearch.q12)
    score13 = Answer.find_by(id: @packsearch.q13)
    
    #pegando os ranges e quantidade de pesquisas cadastrados na categoria criada
    @ranges = Category.find_by(link: 'packsearches')
    
    @total_score = score1.score.to_i + score2.score.to_i + score3.score.to_i + score4.score.to_i + score5.score.to_i + score6.score.to_i + score7.score.to_i + score8.score.to_i + score9.score.to_i + score10.score.to_i + score11.score.to_i + score12.score.to_i + score13.score.to_i
    @total_score = @total_score.fdiv(@ranges.qnt_question.to_i).round(2)
    
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
    @show_solution11 = Solution.find_by(answer_id: @q11)
    @show_solution12 = Solution.find_by(answer_id: @q12)
    @show_solution13 = Solution.find_by(answer_id: @q13)
  end

  # GET /packsearches/new
  def new
    @packsearch = Packsearch.new
    
  end

  # GET /packsearches/1/edit
  def edit
  end

  # POST /packsearches
  # POST /packsearches.json
  def create
   @packsearch = Packsearch.new(packsearch_params)
   #verifica se todos os campos estão preenchidos
   if packsearch_params[:client].blank? || packsearch_params[:phone].blank? || packsearch_params[:q1].blank? || packsearch_params[:q2].blank? || packsearch_params[:q3].blank? || packsearch_params[:q4].blank? || packsearch_params[:q5].blank? || packsearch_params[:q6].blank? || packsearch_params[:q7].blank? || packsearch_params[:q8].blank? || packsearch_params[:q9].blank? || packsearch_params[:q10].blank? || packsearch_params[:q11].blank? || packsearch_params[:q12].blank? || packsearch_params[:q13].blank?
     flash[:warning] = 'Os dados do cliente e todas as perguntas precisam ser respondidas!'
     redirect_to new_packsearch_path and return
   end
    
    respond_to do |format|
      @packsearch.user_id = current_user.id
      @packsearch.user = current_user.name
      @packsearch.status = 'NÃO DEFINIDO'
      @packsearch.finished = 'NÃO'
      
      if @packsearch.save
        
            #ESTE BLOCO DE CODE É UTILIZADO PARA ATUALIZAR AS METAS DO USUÁRIO SEMPRE QUE CRIAR/ATUALIZAR/DELETAR PESQUISA
        #calculando o total de agendamentos do dia
        @total_qnt = Meeting.where(start_time: Date.today).where(clerk_id: current_user.id).where(status: 'EM ANDAMENTO').count

                  
        #calcula os totais por categoria de pesquisa com base no usuário logado
        @total_rodo = Rodosearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_air = Airsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_pack = Packsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_meeting = Meeting.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(clerk_id: current_user.id).where(status: 'COMPROU').sum(:cotation_value)
        @total_research = @total_rodo.to_f + @total_air.to_f + @total_pack.to_f + @total_meeting.to_f
        @total_research = @total_research.round(2)
        #calcula o percentual já vendido
        @current_goal = (@total_research.to_f / current_user.goal.to_f) * 100
        @current_goal = @current_goal.round(2)
        
        #atualiza os dados de meta mensal do usuário
        User.update(current_user.id, qnt_research: @total_qnt.to_i, total_sale: @total_research, current_percent: @current_goal.to_f)
     #-----------------------------------FIM DO BLOCO-------------------------------------------------------------
        
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou nova pesquisa - Pacote de Viagem / Cliente ' + packsearch_params[:client].to_s
        log.save!
        
        #faz o calculo do score pra atualizar o tipo de cliente na tabela
        score1 = Answer.find_by(id: packsearch_params[:q1])
        score2 = Answer.find_by(id: packsearch_params[:q2])
        score3 = Answer.find_by(id: packsearch_params[:q3])
        score4 = Answer.find_by(id: packsearch_params[:q4])
        score5 = Answer.find_by(id: packsearch_params[:q5])
        score6 = Answer.find_by(id: packsearch_params[:q6])
        score7 = Answer.find_by(id: packsearch_params[:q7])
        score8 = Answer.find_by(id: packsearch_params[:q8])
        score9 = Answer.find_by(id: packsearch_params[:q9])
        score10 = Answer.find_by(id: packsearch_params[:q10])
        score11 = Answer.find_by(id: packsearch_params[:q11])
        score12 = Answer.find_by(id: packsearch_params[:q12])
        score13 = Answer.find_by(id: packsearch_params[:q13])
        
        #pegando os ranges e quantidade de pesquisas cadastrados na categoria criada
        @ranges = Category.find_by(link: 'packsearches')
        
        @total_score = score1.score.to_i + score2.score.to_i + score3.score.to_i + score4.score.to_i + score5.score.to_i + score6.score.to_i + score7.score.to_i + score8.score.to_i + score9.score.to_i + score10.score.to_i + score11.score.to_i + score12.score.to_i + score13.score.to_i
        @total_score = @total_score.fdiv(@ranges.qnt_question.to_i).round(2)
        
        check_score = Packsearch.find_by(id: @packsearch)
                    
              if @total_score > @ranges.r1.to_f && @total_score <= @ranges.r2.to_f
              check_score.update_attributes(type_client: 'FRIO')
              elsif @total_score >= @ranges.r3.to_f && @total_score <= @ranges.r4.to_f
              check_score.update_attributes(type_client: 'MORNO') 
              elsif @total_score >= @ranges.r5.to_f && @total_score <= @ranges.r6.to_f
              check_score.update_attributes(type_client: 'QUENTE')
              end  
                
        #cadastrando automáticamente esse cliente pesquisado no cadastro de clientes
        client = Client.new(params[:client])
        client.name = packsearch_params[:client]
        client.cellphone = packsearch_params[:phone]
        client.save!
                      
        format.html { redirect_to @packsearch, notice: 'Pesquisa criada com sucesso.' }
        format.json { render :show, status: :created, location: @packsearch }
      else
        format.html { render :new }
        format.json { render json: @packsearch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packsearches/1
  # PATCH/PUT /packsearches/1.json
  def update
    
    if packsearch_params[:user].blank? || packsearch_params[:client].blank? || packsearch_params[:phone].blank?
     flash[:warning] = 'Selecione o atendente e informe o nome e Celular do cliente!'
     redirect_to edit_packsearch_path(@packsearch) and return
    end
        
    #atualizando o atendente caso tenha sido feita a alteração para outro atendente
    if packsearch_params[:user] != current_user.name
    go_update = 'yes'  
    @id_usuario = User.find_by(name: packsearch_params[:user])
    end 
    
    respond_to do |format|
      if @packsearch.update(packsearch_params)
        
       #ESTE BLOCO DE CODE É UTILIZADO PARA ATUALIZAR AS METAS DO USUÁRIO SEMPRE QUE CRIAR/ATUALIZAR/DELETAR PESQUISA
        #calculando o total de agendamentos do dia
        @total_qnt = Meeting.where(start_time: Date.today).where(clerk_id: current_user.id).where(status: 'EM ANDAMENTO').count

                  
        #calcula os totais por categoria de pesquisa com base no usuário logado
        @total_rodo = Rodosearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_air = Airsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_pack = Packsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_meeting = Meeting.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(clerk_id: current_user.id).where(status: 'COMPROU').sum(:cotation_value)
        @total_research = @total_rodo.to_f + @total_air.to_f + @total_pack.to_f + @total_meeting.to_f
        @total_research = @total_research.round(2)
        #calcula o percentual já vendido
        @current_goal = (@total_research.to_f / current_user.goal.to_f) * 100
        @current_goal = @current_goal.round(2)
        
        #atualiza os dados de meta mensal do usuário
        User.update(current_user.id, qnt_research: @total_qnt.to_i, total_sale: @total_research, current_percent: @current_goal.to_f)
     #-----------------------------------FIM DO BLOCO-------------------------------------------------------------
        
        #ATUALIZOU DADOS
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Gerenciou pesquisa atualizando dados - Pacote de Viagem / Cliente ' + @packsearch.client.to_s
        log.save!
        
        #faz o calculo do score pra atualizar o tipo de cliente na tabela
        score1 = Answer.find_by(id: packsearch_params[:q1])
        score2 = Answer.find_by(id: packsearch_params[:q2])
        score3 = Answer.find_by(id: packsearch_params[:q3])
        score4 = Answer.find_by(id: packsearch_params[:q4])
        score5 = Answer.find_by(id: packsearch_params[:q5])
        score6 = Answer.find_by(id: packsearch_params[:q6])
        score7 = Answer.find_by(id: packsearch_params[:q7])
        score8 = Answer.find_by(id: packsearch_params[:q8])
        score9 = Answer.find_by(id: packsearch_params[:q9])
        score10 = Answer.find_by(id: packsearch_params[:q10])
        score11 = Answer.find_by(id: packsearch_params[:q11])
        score12 = Answer.find_by(id: packsearch_params[:q12])
        score13 = Answer.find_by(id: packsearch_params[:q13])
        
        #pegando os ranges e quantidade de pesquisas cadastrados na categoria criada
        @ranges = Category.find_by(link: 'packsearches')
        
        @total_score = score1.score.to_i + score2.score.to_i + score3.score.to_i + score4.score.to_i + score5.score.to_i + score6.score.to_i + score7.score.to_i + score8.score.to_i + score9.score.to_i + score10.score.to_i + score11.score.to_i + score12.score.to_i + score13.score.to_i
        @total_score = @total_score.fdiv(@ranges.qnt_question.to_i).round(2)
        
        check_score = Packsearch.find_by(id: @packsearch)
                    
        #se houve alteração de atendente é atualizado na pesquisa e na agenda
        if go_update == 'yes'
        check_score.update_attributes(user_id: @id_usuario.id)
        #pegando os dados lá na agenda pra atualizar o id do atendente trocado na pesquisa
        @caminho = 'packsearches/' + @packsearch.id.to_s
        meeting_data = Meeting.find_by(research_path: @caminho)
        meeting_data.update_attributes(clerk_id: @id_usuario.id)
        end 
        
        #para atualizar sempre na pesquisa o perfil do cliente quando a pesquisa for editada
        @caminho = 'packsearches/' + @packsearch.id.to_s
        meeting_data = Meeting.find_by(research_path: @caminho)  
                    
              if @total_score > @ranges.r1.to_f && @total_score <= @ranges.r2.to_f
              check_score.update_attributes(type_client: 'FRIO')
              meeting_data.update_attributes(type_client: 'FRIO')
              elsif @total_score >= @ranges.r3.to_f && @total_score <= @ranges.r4.to_f
              check_score.update_attributes(type_client: 'MORNO')
              meeting_data.update_attributes(type_client: 'MORNO') 
              elsif @total_score >= @ranges.r5.to_f && @total_score <= @ranges.r6.to_f
              check_score.update_attributes(type_client: 'QUENTE')
              meeting_data.update_attributes(type_client: 'QUENTE')
              end
                 
        format.html { redirect_to @packsearch, notice: 'Pesquisa atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @packsearch }
      else
        format.html { render :edit }
        format.json { render json: @packsearch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packsearches/1
  # DELETE /packsearches/1.json
  def destroy
    @packsearch.destroy
    Document.destroy_all(owner: @packsearch)
    Meeting.destroy_all(research_id: @packsearch)
    
        #ESTE BLOCO DE CODE É UTILIZADO PARA ATUALIZAR AS METAS DO USUÁRIO SEMPRE QUE CRIAR/ATUALIZAR/DELETAR PESQUISA
        #calculando o total de agendamentos do dia
        @total_qnt = Meeting.where(start_time: Date.today).where(clerk_id: current_user.id).where(status: 'EM ANDAMENTO').count

                  
        #calcula os totais por categoria de pesquisa com base no usuário logado
        @total_rodo = Rodosearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_air = Airsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_pack = Packsearch.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(user_id: current_user.id).where(finished: 'SIM').sum(:cotation_value)
        @total_meeting = Meeting.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).where(clerk_id: current_user.id).where(status: 'COMPROU').sum(:cotation_value)
        @total_research = @total_rodo.to_f + @total_air.to_f + @total_pack.to_f + @total_meeting.to_f
        @total_research = @total_research.round(2)
        #calcula o percentual já vendido
        @current_goal = (@total_research.to_f / current_user.goal.to_f) * 100
        @current_goal = @current_goal.round(2)
        
        #atualiza os dados de meta mensal do usuário
        User.update(current_user.id, qnt_research: @total_qnt.to_i, total_sale: @total_research, current_percent: @current_goal.to_f)
     #-----------------------------------FIM DO BLOCO-------------------------------------------------------------
     
    respond_to do |format|
      format.html { redirect_to packsearches_url, notice: 'Pesquisa Excluida com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_packsearch
      @packsearch = Packsearch.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def packsearch_params
      params.require(:packsearch).permit(:user, :client, :phone, :q1, :q2, :q3, :q4, :q5, :q6, :q7, :q8, :q9, :q10, :q11, :q12, :q13, :status, :obs, :schedule, :reason, :pains, :solution_applied, :cotation_value, :finished, :user_id)
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
      @question11 = Question.find_by(id: '11')
      @question12 = Question.find_by(id: '12')
      @question13 = Question.find_by(id: '13')
      
      
      if @question1.blank? || @question2.blank? || @question3.blank? || @question4.blank? || @question5.blank? || @question6.blank? || @question7.blank? || @question8.blank? || @question9.blank? || @question10.blank? || @question11.blank? || @question12.blank? || @question13.blank?
      flash[:warning] = "Você precisa cadastrar primeiro as 13 perguntas e respostas com as tratativas para esta pesquisa!"
      redirect_to questions_path and return
      end  
           
    end
    def show_user
      @users = User.where('type_access != ?', 'MASTER').order(:name)
    end
end
