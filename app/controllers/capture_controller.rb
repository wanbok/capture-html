class CaptureController < ApplicationController
  protect_from_forgery except: :create

  def create
    if params[:product]# && params[:html]
      Dir.mkdir 'files' unless Dir.exist? 'files'
      image_name = 'files/' + params[:product] + '.jpg'
      unless File.exist? image_name
        kit = capture(params)
        img = Magick::Image::from_blob(kit.to_jpg).first

        sigma = params[:sigma] || "20.0"
        img.blur_image(0.0, sigma.to_f).write image_name
      end

      File.open(image_name, 'rb') do |f|
        send_data f.read,
          filename: image_name,
          type: 'image/jpeg',
          disposition: 'inline'
      end
    else
      msg = {
        message: "product and html is required."
      }
      render json: msg, status: :bad_request
    end
  end

  private
  def capture params
    width = params[:width] || 0
    height = params[:height] || 0
    quality = params[:quality] || 30
    # IMGKit.new(params[:html], width: width, height: height, quality: quality)
    IMGKit.new(File.new('files/115310.html'), width: width, height: height, quality: quality)
  end
end