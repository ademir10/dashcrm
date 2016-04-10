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
    @airsearch = Airsearch.find(params[:id])
    @documents = Document.where(owner: @airsearch.id).order(:created_at)
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
    @airsearch = Airsearch.find_by_id(params[:air_id])
    
    @document = Document.new
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    respond_to do |format|
      
      if @document.save
        format.html { redirect_to airsearches_path, notice: 'Arquivo salvo com sucesso.' }
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
      format.html { redirect_to documents_url }
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
      params.require(:document).permit(:file, :owner)
    end
end