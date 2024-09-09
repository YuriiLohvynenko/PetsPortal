class VisitsController < ApplicationController
  def index
    @visits = Visit.where(visited_id: current_user.id, created_at: Time.zone.today.all_day).unread
  end

  def read
    @visit = Visit.find(params[:visit_id])

    @visit.update!(read: true)

    if @visit.visitor && !@visit.visitor.deleted_at
      redirect_to user_path(@visit.visitor)
    else
      redirect_to my_page_path
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to my_page_path, alert: e.record.errors.full_messages.join(", ")
  end

end
