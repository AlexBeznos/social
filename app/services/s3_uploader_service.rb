class S3UploaderService
  require 'aws-sdk'

  def self.upload_zip(archive)
    upload_file(archive, File.extname(archive)) if File.exist?(archive)
  end

  def self.delete_settings_archive_by_url(url)
    if uri?(url)
      file = URI.parse(url).path[1..-1]

      s3 = AWS::S3.new
      bucket = s3.buckets[get_bucket_name]
      obj = bucket.objects[file]
      obj.delete
    end
  end

  private

    def self.upload_file(file, extension)
      s3 = AWS::S3.new
      bucket = s3.buckets[get_bucket_name]
      key = [SecureRandom.uuid, extension].join('')
      object = bucket.objects.create(key, File.open(file), acl: :public_read)
      return object.public_url.to_s
    end

    def self.get_bucket_name
      'gowifi-prod' # NOTE: Change it before deployment
    end

    def self.uri?(string)
      uri = URI.parse(string)
      %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end

end
