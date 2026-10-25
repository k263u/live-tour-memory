class TripsController < ApplicationController
  before_action :require_login
  before_action :set_trip, only: %i[show edit update destroy]

  def new
    @trip = Trip.new
  end

  def create
    @trip = current_user.trips.build(trip_params)

    ActiveRecord::Base.transaction do
      @trip.save!
      save_photos!
    end

    redirect_to trips_path, notice: "遠征記録を作成しました"
  rescue ActiveRecord::RecordInvalid, CarrierWave::IntegrityError, CarrierWave::ProcessingError
    @trip.errors.add(:base, "写真をアップロードできませんでした") if @trip.errors.empty?
    render :new, status: :unprocessable_content
  end

  def index
    @trips = current_user.trips.order(event_date: :desc)
  end

  def show
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      @trip.update!(trip_params)
      save_photos!
    end

    redirect_to trip_path(@trip), notice: "遠征記録を更新しました"
  rescue ActiveRecord::RecordInvalid, CarrierWave::IntegrityError, CarrierWave::ProcessingError
    @trip.errors.add(:base, "写真をアップロードできませんでした") if @trip.errors.empty?
    render :edit, status: :unprocessable_content
  end

  def destroy
    @trip.destroy
    redirect_to trips_path, notice: "遠征記録を削除しました"
  end

  private

    def trip_params
      params.require(:trip).permit(
        :live_name,
        :artist_name,
        :event_date,
        :venue,
        :hotel,
        :transportation,
        :ticket_cost,
        :transportation_cost,
        :accommodation_cost,
        :other_cost,
        :other_cost_memo,
        :memo,
        images: []
      )
    end

    def set_trip
      @trip = current_user.trips.find_by(id: params[:id])
      return if @trip

      redirect_to trips_path, alert: "遠征記録が見つかりません"
    end

    def save_photos!
      @trip.images&.reject(&:blank?)&.each do |image|
        @trip.photos.create!(image: image)
      end
    end
end
