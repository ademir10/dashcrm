class ResearchesController < ApplicationController
  before_action :set_research, only: [:show, :edit, :update, :destroy]
  before_action :show_category, only: [:show, :new, :edit, :update, :create]

  # GET /researches
  # GET /researches.json
  def index
    @researches = Research.all
  end

  # GET /researches/1
  # GET /researches/1.json
  def show
    @questions = Question.where(id: '6')
  end

  # GET /researches/new
  def new
    @research = Research.new
  end

  # GET /researches/1/edit
  def edit
  end

  # POST /researches
  # POST /researches.json
  def create
    @research = Research.new(research_params)
    @research.user = current_user.name
    respond_to do |format|
      if @research.save
        format.html { redirect_to @research, notice: 'Dados do cliente criados com sucesso, responda as perguntas.' }
        format.json { render :show, status: :created, location: @research }
      else
        format.html { render :new }
        format.json { render json: @research.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /researches/1
  # PATCH/PUT /researches/1.json
  def update
    respond_to do |format|
      if @research.update(research_params)
        format.html { redirect_to @research, notice: 'Dados do cliente alterados com sucesso.' }
        format.json { render :show, status: :ok, location: @research }
      else
        format.html { render :edit }
        format.json { render json: @research.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /researches/1
  # DELETE /researches/1.json
  def destroy
    @research.destroy
    respond_to do |format|
      format.html { redirect_to researches_url, notice: 'Pesquisa excluida com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_research
      @research = Research.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def research_params
      params.require(:research).permit(:category_id, :user, :client, :cellphone)
    end
    
    def show_category
      @categories = Category.order(:name)
    end
end
