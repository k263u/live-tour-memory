FactoryBot.define do
  factory :photo do
    association :trip
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test_image.png"), "image/png") }
  end
end
