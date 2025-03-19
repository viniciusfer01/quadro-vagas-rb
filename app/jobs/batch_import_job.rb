class BatchImportJob < ApplicationJob
  queue_as :default

  USER_INDEX_EMAIL = 1
  USER_INDEX_NAME = 2
  USER_INDEX_LAST_NAME = 3
  USER_INDEX_PASSWORD = 4

  COMPANY_PROFILE_INDEX_NAME = 1
  COMPANY_PROFILE_INDEX_WEB_SITE = 2
  COMPANY_PROFILE_INDEX_CONTACT_EMAIL = 3
  COMPANY_PROFILE_INDEX_USER = 4

  JOB_POSTING_INDEX_TITLE = 1
  JOB_POSTING_INDEX_SALARY = 2
  JOB_POSTING_INDEX_SALARY_CURRENCY = 3
  JOB_POSTING_INDEX_SALARY_PERIOD = 4
  JOB_POSTING_INDEX_WORK_ARRANGEMENT = 5
  JOB_POSTING_INDEX_JOB_TYPE = 6
  JOB_POSTING_INDEX_JOB_LOCATION = 7
  JOB_POSTING_INDEX_EXPERIENCE_LEVEL = 8
  JOB_POSTING_INDEX_COMPANY_PROFILE = 9
  JOB_POSTING_INDEX_DESCRIPTION = 10

  def perform(line, user_id, index)
    return if line.blank?
    line_striped = line.strip
    action = line_striped[0]
    data = line_striped.split(",")

    case action
    when "U"
      object = build_user(data)
    when "E"
      object = build_company_profile(data)
    when "V"
      object = build_job_posting(data)
    else
      puts "Linha inválida: #{line}"
    end

    redis = Redis.new(url: ENV["REDIS_URL"])
    processed = redis.get("job-data-user-#{user_id}-processed-lines").to_i
    remaining = redis.get("job-data-user-#{user_id}-remaining-lines").to_i
    successful_registrations = redis.get("job-data-user-#{user_id}-successful-registrations").to_i
    errors = redis.get("job-data-user-#{user_id}-lines-error").to_i
    errors_list = JSON.parse(redis.get("job-data-user-#{user_id}-lines-error-list"))


    if object.valid?
      successful_registrations += 1 if object.save
    else
      erro_mensagem = "Erro na linha #{index + 1}: #{object.errors.full_messages.join(', ')}"
      errors_list.push(erro_mensagem)
      errors += 1
    end

    processed += 1
    remaining -= 1

    redis.set("job-data-user-#{user_id}-processed-lines", processed)
    redis.set("job-data-user-#{user_id}-remaining-lines", remaining)
    redis.set("job-data-user-#{user_id}-successful-registrations", successful_registrations)
    redis.set("job-data-user-#{user_id}-lines-error", errors)
    redis.set("job-data-user-#{user_id}-lines-error-list", errors_list.to_json)

    Turbo::StreamsChannel.broadcast_update_to(
      "progress_channel",
      target: "progress_channel_container",
      partial: "shared/progress_channel",
      locals: {
        processed: processed,
        remaining: remaining,
        successful_registrations: successful_registrations,
        errors: errors,
        errors_list: errors_list
      }
    )
  rescue StandardError => e
    puts "Erro ao processar linha: #{line} - #{e.message}"
  end

  private

  def build_user(data)
    password = SecureRandom.alphanumeric(10)
    User.new(email_address: data[USER_INDEX_EMAIL], name: data[USER_INDEX_NAME],
                last_name: data[USER_INDEX_LAST_NAME], password: password,
                password_confirmation: password)
  end

  def build_company_profile(data)
    company = CompanyProfile.new(name: data[COMPANY_PROFILE_INDEX_NAME], contact_email: data[COMPANY_PROFILE_INDEX_CONTACT_EMAIL],
                                 website_url: data[COMPANY_PROFILE_INDEX_WEB_SITE], user_id: data[COMPANY_PROFILE_INDEX_USER])
    company.logo.attach(io: File.open(Rails.root.join("spec/support/files/logo.jpg")), filename: "logo.jpg")
    company
  end

  def build_job_posting(data)
    salary_currency = data[JOB_POSTING_INDEX_SALARY_CURRENCY].downcase.to_sym
    salary_period = JobPosting.translate_enum(data[JOB_POSTING_INDEX_SALARY_PERIOD], "salary_periods", :'pt-BR', :en)
    work_arrangement = JobPosting.translate_enum(data[JOB_POSTING_INDEX_WORK_ARRANGEMENT], "work_arrangements", :'pt-BR', :en)
    JobPosting.new(title: data[JOB_POSTING_INDEX_TITLE], company_profile_id: data[JOB_POSTING_INDEX_COMPANY_PROFILE],
                      job_type_id: data[JOB_POSTING_INDEX_JOB_TYPE], experience_level_id: data[JOB_POSTING_INDEX_EXPERIENCE_LEVEL],
                      salary: data[JOB_POSTING_INDEX_SALARY], salary_currency: salary_currency, salary_period: salary_period.downcase.to_sym,
                      work_arrangement: work_arrangement.downcase.to_sym, job_location: data[JOB_POSTING_INDEX_JOB_LOCATION],
                      description: data[JOB_POSTING_INDEX_DESCRIPTION])
  end
end
