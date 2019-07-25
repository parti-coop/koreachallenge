class TinymceAssetsController < ApplicationController
  def create
    image = Image.create params.permit(:file, :alt, :hint)

    if image.errors.empty?
      render json: {
        image: {
          url: image.file.url
        }
      }, content_type: "text/html"
    else
      render json: {
        error: {
          message: errors_to_str(image, "\n")
        }
      }, content_type: "text/html"
    end
  end
end
