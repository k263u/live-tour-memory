class R2ConnectionTestController < ApplicationController
  def show
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("R2 production connection test"),
      filename: "r2-production-test.txt",
      content_type: "text/plain"
    )

    downloaded = blob.download
    blob.purge

    if downloaded == "R2 production connection test"
      render plain: "R2 connection OK"
    else
      render plain: "R2 connection NG", status: :internal_server_error
    end
  rescue StandardError => e
    render plain: "R2 connection failed: #{e.class}", status: :internal_server_error
  end
end
