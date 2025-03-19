require 'rails_helper'

RSpec.describe ProcessTxtJob, type: :job do
  it 'Open job' do
    Rails.root.join('spec/fixtures/job_postings.txt')
    BatchImportJob.perform_later('line', 1, 1)

    expect(enqueued_jobs.size).to eq(1)
  end

  it 'Creating a user' do
    user = create(:user)
    redis = Redis.new(url: ENV["REDIS_URL"])
    redis.set("job-data-user-#{user.id}-lines-error-list", [].to_json)

    BatchImportJob.perform_later("U,usuario2@example.com,Nome do usuario,sobrenome,password123", user.id, 1)
    perform_enqueued_jobs

    expect(User.count).to eq(2)
    user_from_job = User.last
    expect(user_from_job.attributes.deep_symbolize_keys).to include({ email_address: 'usuario2@example.com', name: 'Nome do usuario',
                                                                      last_name: 'sobrenome' })
  end

  it 'Creating a company profile' do
    user = create(:user)
    user_for_job = create(:user, email_address: 'usuario1@example.com')
    redis = Redis.new(url: ENV["REDIS_URL"])
    redis.set("job-data-user-#{user.id}-lines-error-list", [].to_json)

    BatchImportJob.perform_later("E,Empresa A,https://www.empresa-a.com,contato@empresa-a.com,#{user_for_job.id}", user.id, 1)
    perform_enqueued_jobs

    expect(CompanyProfile.count).to eq(1)
    company_profile_from_job = CompanyProfile.first
    expect(company_profile_from_job.attributes.deep_symbolize_keys).to include({ name: 'Empresa A', website_url: 'https://www.empresa-a.com',
                                                                                 contact_email: 'contato@empresa-a.com', user_id: user_for_job.id })
  end

  it 'Creating a job posting' do
    user = create(:user)
    company = create(:company_profile, user: user)
    job_type = create(:job_type)
    experience_level = create(:experience_level)
    redis = Redis.new(url: ENV["REDIS_URL"])
    redis.set("job-data-user-#{user.id}-lines-error-list", [].to_json)

    BatchImportJob.perform_later("V,Desenvolvedor Ruby on Rails,15000,BRL,Mensal,Presencial,
                                 #{job_type.id},São Paulo,#{experience_level.id},#{company.id},descrição da vaga", user.id, 1)
    perform_enqueued_jobs

    expect(JobPosting.count).to eq(1)
    job_posting_from_job = JobPosting.first
    expect(job_posting_from_job.attributes.deep_symbolize_keys).to include({ title: 'Desenvolvedor Ruby on Rails', salary: BigDecimal('15000'),
                                                                             salary_currency: 'brl', salary_period: 'monthly', work_arrangement: 'in_person',
                                                                             job_type_id: job_type.id, experience_level_id: experience_level.id,
                                                                             job_location: 'São Paulo', company_profile_id: company.id })
    expect(job_posting_from_job.description.to_plain_text).to eq('descrição da vaga')
  end
end
