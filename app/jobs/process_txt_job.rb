class ProcessTxtJob < ApplicationJob
  queue_as :default

  def perform(file_path, user_id)
    redis = Redis.new(url: ENV["REDIS_URL"])
    lines = File.readlines(file_path)
    redis.set("job-data-user-#{user_id}-processed-lines", "0")
    redis.set("job-data-user-#{user_id}-remaining-lines", lines.size)
    redis.set("job-data-user-#{user_id}-successful-registrations", "0")
    redis.set("job-data-user-#{user_id}-lines-error", "0")
    redis.set("job-data-user-#{user_id}-lines-error-list", [].to_json)
    sleep 2
    lines.each_with_index { |line, index| BatchImportJob.perform_later(line, user_id, index) }
    File.delete(file_path) if File.exist?(file_path)
  end
end
