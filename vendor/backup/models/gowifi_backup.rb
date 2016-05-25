# encoding: utf-8

##
# Backup Generated: gowifi_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t gowifi_backup [-c <path_to_configuration_file>]


#NOTE: To remove this shit we need ro include db configuration in application.yml
db_config_path = Dir.pwd + "/config/database.yml"
DB = YAML.load_file(db_config_path)[ENV["RAILS_ENV"]]


Backup::Model.new(:gowifi_backup, 'Every day backup, storing in AWS.') do

  split_into_chunks_of 250

  database PostgreSQL do |db|
    db.name               = DB["database"]
    db.username           = DB["username"]
    db.password           = DB["password"]
    db.host               = DB["host"]
  end

  store_with S3 do |s3|
    # AWS Credentials
    s3.access_key_id     = ENV["AWS_ACCESS_KEY_ID"]
    s3.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]

    s3.region             = ENV["AWS_REGION"]
    s3.bucket             = ENV["AWS_BUCKET"]
    s3.path               = '/backups'
  end

  notify_by Slack do |slack|
    slack.on_success = true
    slack.on_warning = true
    slack.on_failure = true

    slack.webhook_url = ENV["SLACK_WEB_HOOK"]

  end



  compress_with Gzip
end
