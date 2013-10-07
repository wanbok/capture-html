class CaptureController < ApplicationController
  protect_from_forgery except: :craete

  def create
    if params[:url]
      kit = capture(params)
      img = Magick::Image::from_blob(kit.to_jpg).first

      sigma = params[:sigma] || "20.0"
      send_data img.blur_image(0.0, sigma.to_f).to_blob,
        filename: 'image.jpg',
        type: 'image/jpeg',
        disposition: 'inline'
    else
      msg = {
        message: "url is required."
      }
      render json: msg, status: :bad_request
    end
  end

  private
  def capture params
    width = params[:width] || 0
    height = params[:height] || 0
    quality = params[:quality] || 30
    IMGKit.new(params[:url], width: width, height: height, quality: quality)
  end
end