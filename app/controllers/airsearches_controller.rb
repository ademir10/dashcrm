class AirsearchesController < ApplicationController
  before_action :set_airsearch, only: [:show, :edit, :update, :destroy]
  before_action :show_question, only: [:show, :new, :edit, :update, :destroy]
  before_action :must_login
  
  #para atualizar os dados como o status, agendamento e inserir arquivos para upload
  def update_status_air
    
    @airsearch = Airsearch.find(params[:id])
    
    if airsearch_params[:status].blank? && airsearch_params[:schedule].blank?
      flash[:warning] = 'Informe o Status e se for o caso uma data para agendamento!'
      redirect_to airsearch_path(@airsearch) and return
    elsif airsearch_params[:status] == 'NÃO COMPROU' && airsearch_params[:schedule].present?
      flash[:warning] = 'Você informou uma data para retorno e não informou o status corretamente, volte e atualize esta pesquisa!'
      redirect_to airsearch_path(@airsearch) and return
    end
    
    @airsearch.update(airsearch_params)
    flash[:success] = 'Os dados foram atualizados com sucesso!'   
    redirect_to airsearches_path and return
   
   
    
  end

  #gerenciamento da pesquisa
  def manage_air
  @result = Airsearch.find_by(id: params[:air_id])
  end

  def index
    @airsearches = Airsearch.all
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
      @airsearch.user = current_user.name
      @airsearch.status = 'NÃO DEFINIDO'
      
      if @airsearch.save
        
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
      params.require(:airsearch).permit(:client, :phone, :q1, :q2, :q3, :q4, :q5, :q6, :q7, :q8, :q9, :q10, :status, :obs, :schedule)
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
