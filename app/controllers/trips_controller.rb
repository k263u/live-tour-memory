class TripsController < ApplicationController
  before_action :require_login

  def new
    @trip = Trip.new
  end

  def create
    @trip = current_user.trips.build(trip_params)

    if @trip.save
      redirect_to root_path, notice: "遠征記録を作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def index
    @trips = current_user.trips.order(event_date: :desc)
  end

  def show
    @trip = current_user.trips.find_by(id: params[:id])

    redirect_to trips_path, alert: "遠征記録が見つかりません" unless @trip
  end

  def edit
    @trip = current_user.trips.find_by(id: params[:id])

    redirect_to trips_path, alert: "遠征記録が見つかりません" unless @trip
  end

  def update
   @trip = current_user.trips.find_by(id: params[:id])

   unless @trip
    redirect_to trips_path, alert: "遠征記録が見つかりません"
    return
   end

  if @trip.update(trip_params)
    redirect_to trip_path(@trip), notice: "遠征記録を更新しました"
  else
    render :edit, status: :unprocessable_content
  end
end

  private

  def trip_params
    params.require(:trip).permit(:live_name, :artist_name, :event_date, :venue, :hotel, :transportation, :cost, :memo)
  end
end
