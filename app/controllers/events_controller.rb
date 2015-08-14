class EventsController < ApplicationController
  before_filter :require_verified_user, except: :show

  def index
    if params[:start_time] && params[:end_time]
      @events = Event.where('start_date_and_time BETWEEN ? AND ?', params[:start_time], params[:end_time])
                     .includes(:attendances)
    else
      @events = Event.future_events
    end
    respond_to do |format|
      format.html
      format.json do
        render json: @events.as_json.merge(number_of_attendees: event.attendances.size)
      end
    end
  end

  def show
    @rand_image_number = rand(1..10)
    unless current_user and current_user.verified?
      session[:redirect_url] = "/events/#{params[:id]}"
    end
    @event = Event.find(params[:id])
    @attend = Attendance.find_by(event: @event, user_id: session[:user_id])
    @out_nudge = Nudge.find_by(event: @event, nudger_id: session[:user_id])
    @in_nudge = Nudge.find_by(event: @event, nudgee_id: session[:user_id])
    flash[:attendance] = @attend.id if @attend
  end

end
