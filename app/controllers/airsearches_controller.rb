class AirsearchesController < ApplicationController
  before_action :set_airsearch, only: [:show, :edit, :update, :destroy]
  before_action :show_question, only: [:new, :edit, :update, :destroy]
 
  # GET /airsearches
  # GET /airsearches.json
  def index
    @airsearches = Airsearch.all
  end

  # GET /airsearches/1
  # GET /airsearches/1.json
  def show
    @r1 = Quiz.find(@airsearch.q1)
    @r2 = Quiz.find(@airsearch.q2)
    @r3 = Quiz.find(@airsearch.q3)
    
    
    #faz o calculo do score pra saber se o cliente é quente, morno ou frio
    score1 = Quiz.find_by(id: @airsearch.q1)
    score2 = Quiz.find_by(id: @airsearch.q2)
    score3 = Quiz.find_by(id: @airsearch.q3)
    
    @total_score = score1.score.to_i + score2.score.to_i + score3.score.to_i
    @total_score = @total_score / 3
    
    #trazendo os conselhos
    if @total_score > 0 && @total_score <= 2
    @advices = Advice.where(type_advice: 'FRIO')
    
    elsif @total_score >= 3 && @total_score <= 6
    @advices = Advice.where(type_advice: 'MORNO')
    elsif @total_score >= 7 && @total_score <= 10
    @advices = Advice.where(type_advice: 'QUENTE')
    end  
      
       
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
   if airsearch_params[:client].blank? || airsearch_params[:phone].blank? || airsearch_params[:q1].blank? || airsearch_params[:q2].blank? || airsearch_params[:q3].blank?
     flash[:warning] = 'Os dados do cliente e todas as perguntas precisam ser respondidas!'
     redirect_to new_airsearch_path and return
   end
    
    respond_to do |format|
      if @airsearch.save
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
      params.require(:airsearch).permit(:client, :phone, :q1, :q2, :q3)
    end
    
    def show_question
      @q1 = Quiz.find_by(id: '1')
      @q2 = Quiz.find_by(id: '2')
      @q3 = Quiz.find_by(id: '5')
      
      @q4 = Quiz.find_by(id: '3')
      @q5 = Quiz.find_by(id: '4')
      
      @q6 = Quiz.find_by(id: '6')
      @q7 = Quiz.find_by(id: '7')
    end
end
