class ResultsController < ApplicationController
  before_action :set_result, only: [:show, :edit, :update, :destroy]

  def edit
  end
  
   def create
   @research = Research.find(params[:research_id])
              
     if result_params[:a1,:a2,:a3,:a4,:a5,:a6,:a7,:a8,:a9,:a10,:a11,:a12,:a13,:a14,:a15,].blank? 
     flash[:warning] = 'Todas as respostas devem ser respondidas!'
     redirect_to research_path(@research) and return
     else 
      @result = @research.results.create(result_params)
      redirect_to research_path(@research)
     end
  end
  
  def destroy
    @research = Research.find(params[:research_id])
    @result = @research.results.find(params[:id])
    @result.destroy
    redirect_to research_path(@research)
  end
  
  private
   
     # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:a1, :a2, :a3, :a4, :a5, :a6, :a7, :a8, :a9, :a10, :a11, :a12, :a13, :a14, :a15, :research_id)
    end

end
