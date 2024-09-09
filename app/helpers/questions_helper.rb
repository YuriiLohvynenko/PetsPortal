module QuestionsHelper
    def question_author(question)
        User.find_by(id: question.user_id)
    end
end
