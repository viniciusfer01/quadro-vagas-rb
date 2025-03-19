class JobBatchesController < ApplicationController
  # before_action :verify_user

  def new
  end

  def create
    uploaded_file = params[:upload]

    if uploaded_file.nil?
      flash.now[:alert] = t(".error")
      return render :new, status: :unprocessable_entity
    end

    file_path = Rails.root.join("tmp", uploaded_file.original_filename)

    if !text_file?(file_path)
      flash.now[:alert] = t(".type_error")
      return render :new, status: :unprocessable_entity
    end

    File.open(file_path, "wb") { |file| file.write(uploaded_file.read) }
    ProcessTxtJob.perform_later(file_path.to_s, Current.user.id)
    redirect_to batch_status_path, notice: t(".success")
  end

  def batch_status
    redis = Redis.new(url: ENV["REDIS_URL"])
    user_id = Current.user.id
    @processed = redis.get("job-data-user-#{user_id}-processed-lines").to_i
    @remaining = redis.get("job-data-user-#{user_id}-remaining-lines").to_i
    @successful_registrations = redis.get("job-data-user-#{user_id}-successful-registrations").to_i
    @errors = redis.get("job-data-user-#{user_id}-lines-error").to_i
    @errors_list = JSON.parse(redis.get("job-data-user-#{user_id}-lines-error-list") || "[]")
  end

  private

  def text_file?(file_path)
    text_extensions = %w[.txt]
    text_extensions.include?(File.extname(file_path).downcase)
  end

  def verify_user
    redirect_to root_path, notice: t(".user_invalid") unless Current.user.admin?
  end
end
