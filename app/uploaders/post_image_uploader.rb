class PostImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/post_images/#{model.class.to_s.underscore}/#{model.id}"
  end

  def content_type_whitelist
    /image\//
  end
end
