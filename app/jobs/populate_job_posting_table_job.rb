class PopulateJobPostingTableJob < ApplicationJob
  queue_as :default

  def perform(title, salary, salary_currency, salary_period, work_arrangement, job_type, experience_level, company_profile, location: nil)
    # check if job_type, experience_level and company_profile exists
    job_type = JobType.find_or_create_by(name: job_type)
    experience_level = ExperienceLevel.find_or_create_by(name: experience_level)
    company_profile = CompanyProfile.find(company_profile.id)

    if job_type.nil? || experience_level.nil? || company_profile.nil?
      return
    end

    salary_currency = parse_currency(salary_currency)
    salary_period = parse_period(salary_period)
    work_arrangement = parse_work_arrangement(work_arrangement)

    if work_arrangement == :in_person || work_arrangement == :hybrid
      if location.nil?
        cancel_job("Location is required for in person or hybrid work arrangements")
      else
        # create job posting
        JobPosting.create!(title: title, salary: salary, salary_currency: salary_currency, salary_period: salary_period, description: "a job",
                           work_arrangement: work_arrangement, job_type: job_type, location: location, experience_level: experience_level, company_profile: company_profile)
      end
    end

    # create job posting
    JobPosting.create!(title: title, salary: salary, salary_currency: salary_currency, salary_period: salary_period, description: "a job",
                       work_arrangement: work_arrangement, job_type: job_type, experience_level: experience_level, company_profile: company_profile)
  end

  def parse_currency(currency)
    case currency
    when "USD"
      :usd
    when "EUR"
      :eur
    when "BRL"
      :brl
    else
      cancel_job("Invalid currency: #{currency}")
    end
  end

  def parse_period(period)
    case period
    when "Diário"
      :daily
    when "Semanal"
      :weekly
    when "Mensal"
      :monthly
    when "Anual"
      :yearly
    else
      cancel_job("Invalid period: #{period}")
    end
  end

  def parse_work_arrangement(work_arrangement)
    case work_arrangement
    when "Remoto"
      :remote
    when "Híbrido"
      :hybrid
    when "Presencial"
      :in_person
    else
      cancel_job("Invalid work arrangement: #{work_arrangement}")
    end
  end

  private

  def cancel_job(message)
    raise ArgumentError, message
  end
end
