class TargetsController < ApplicationController
  before_action :set_target, only: [:show, :edit, :update, :destroy]
  before_action :must_login

  def edit
  end

  def create
    @advice = Advice.find(params[:advice_id])
              
     if target_params[:answer_id].blank? 
     flash[:warning] = 'Selecione uma resposta para agraga-la á tratativa!'
     redirect_to advice_path(@advice) and return
     else 
      @target = @advice.targets.create(target_params)
      redirect_to advice_path(@advice)
     end
    end
  
  def destroy
    @advice = Advice.find(params[:advice_id])
    @target = @advice.targets.find(params[:id])
    puts @target.destroy
    redirect_to advice_path(@advice)
  end
  
  private
   
    # Never trust parameters from the scary internet, only allow the white list through.
    def target_params
      params.require(:target).permit(:advice_id, :answer_id)
    end
end
