class PhotosController < ApplicationController
  before_action :require_login

  def show
    photo = Photo.joins(:trip)
                 .where(trips: { user_id: current_user.id })
                 .find_by(id: params[:id])

    return head :not_found unless photo

    send_data photo.image.read,
              type: photo.image.file.content_type,
              disposition: "inline"
  end

  def destroy
    photo = Photo.joins(:trip)
                 .where(trips: { user_id: current_user.id })
                 .find_by(id: params[:id])

    unless photo
      redirect_to trips_path, alert: "写真が見つかりません"
      return
    end

    trip = photo.trip
    photo.destroy

    redirect_to edit_trip_path(trip), notice: "写真を削除しました"
  end
end
