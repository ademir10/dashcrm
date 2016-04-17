class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :must_login
  
  # para exibir a imagem
  def show_file
  @document = Document.find(params[:id])
  end

  # GET /documents
  # GET /documents.json
  def index
    
    if params[:request] == 'airsearches'
    @data_client = Airsearch.find(params[:id])  
    @documents = Document.where(owner: @data_client.id).order(:created_at)
    #pra guardar o tipo de pesquisa na hora de pedir um novo anexo
    @type_research = 'airsearches'
    end
    
    if params[:request] == 'meetings'
    @data_client = Meeting.find(params[:id])  
    @documents = Document.where(owner: @data_client.id).order(:created_at)
    #pra guardar o tipo de pesquisa na hora de pedir um novo anexo
    @type_research = 'meetings'
    end
    
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    send_data(@document.file_contents,
              type: @document.content_type,
              filename: @document.filename)
  end

  # GET /documents/new
  def new
    if params[:request] == 'airsearches'
      @research = Airsearch.find_by_id(params[:id])
      @type_research = 'airsearches'
    end
        if params[:request] == 'meetings'
      @research = Meeting.find_by_id(params[:id])
      @type_research = 'meetings'
    end
    @document = Document.new
    
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    respond_to do |format|
      
      if @document.save
        #se for um anexo de pesquisa de transportes aéreos
        if @document.type_research == 'airsearches'
        @airsearch = document_params[:owner]
        format.html { redirect_to airsearch_path(@airsearch), notice: 'Arquivo salvo com sucesso.' }
        end
        #se for um anexo vindo de um agendamento simples
        if @document.type_research == 'meetings'
        @meeting = document_params[:owner]
        format.html { redirect_to meeting_path(@meeting), notice: 'Arquivo salvo com sucesso.' }
        end
        
        
        format.json { render action: 'show', status: :created, location: @document }
      else
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to airsearches_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:file, :owner, :type_research)
    end
end