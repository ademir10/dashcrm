class AnswersController < ApplicationController
  before_action :must_login

  def edit
  end
  
  
  
    def create
   @question = Question.find(params[:question_id])
              
      if answer_params[:description].blank? || answer_params[:score].blank? 
     flash[:warning] = 'A descrição da resposta e o score precisam ser informados!'
     redirect_to question_path(@question) and return
     else 
      @answer = @question.answers.create(answer_params)
      redirect_to question_path(@question)
     end
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    @answer.destroy
    redirect_to question_path(@question)
  end
  
  private
   
    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:description, :score, :question_id)
    end
end
