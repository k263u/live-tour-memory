class Photo < ApplicationRecord
  belongs_to :trip

  mount_uploader :image, ImageUploader
end
