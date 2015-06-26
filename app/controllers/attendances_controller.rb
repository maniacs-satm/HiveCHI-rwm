class AttendancesController < ApplicationController
  def new
    unless session[:commitment]
      flash[:redirect_url] = "/events/"+params[:event_id]
      redirect_to "/redirect"
    end
  end

  def create
  	event = Event.find(params[:id])
  	Attendance.create(user: User.find(session[:user_id]), event: event,
  		departure_time: params[:departure_time],
  		method_of_transit: params[:method_of_transit],
  		commitment_status: session[:commitment])
  	flash[:notice] = "You signed up for #{event.name}"
    session[:commitment] = nil
    flash[:redirect_url] = "/dashboard"
    redirect_to "/redirect"
  end

  def update
    Attendance.find(flash[:attendance]).update(commitment_status: params[:update_commit_status])
    flash[:notice] = "Your attendance has been updated"
    flash[:redirect_url] = "/dashboard"
    redirect_to "/redirect"
  end
end