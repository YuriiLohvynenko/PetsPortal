class QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show edit update destroy ]
  before_action :authenticate_user_or_admin!

  # GET /questions or /questions.json
  def index
    @special_category = params[:special_category]
    @status = params[:status]
    @category = params[:category]
    @subcategory = params[:subcategory]
    @free_words = params[:keyword]&.downcase

    @questions = Question.search(@category, @subcategory, @status, @special_category, @free_words).paginate(page: params[:page], per_page: 20)
  end

  # GET /questions/1 or /questions/1.json
  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.order(created_at: :desc)
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)
    @question.user = current_user
    @question.status = "回答受付中"
    respond_to do |format|
      if @question.save
        format.html { redirect_to question_url(@question) }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to question_url(@question)}
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  def my_questions
    @questions = current_user.questions
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:body, :special_category, :user_id, :subcategory_id, :category_id)
    end
end
