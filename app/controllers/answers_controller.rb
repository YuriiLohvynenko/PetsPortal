class AnswersController < ApplicationController
    def create
      @question = Question.find(params[:question_id])
      @answer = @question.answers.new(answer_params)
      @answer.user = current_user

      if @answer.save
        redirect_to @question
      else
        redirect_to @question
      end
    end

    def pick
      @answer = Answer.find(params[:answer_id])
      @question = Question.find(params[:question_id])
      @answer.update(picked: true)
      @question.update(status: "解決済み")
      redirect_to question_path(@question)
    end

    def update
      @question = Question.find(params[:question_id])
      @answer = Answer.find(params[:id])

      if current_user == @answer.user && !@answer.picked?
        if @answer.update(answer_params)
          redirect_to @question
        else
          redirect_to @question
        end
      else
        redirect_to @question
      end
    end


    private

    def answer_params
      params.require(:answer).permit(:body)
    end
  end
