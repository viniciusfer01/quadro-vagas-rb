require 'rails_helper'

RSpec.describe PopulateJobPostingTableJob, type: :job do
  it 'queues the job' do
    JobType.create!(name: 'Full Time')
    ExperienceLevel.create!(name: 'Junior')
    company_profile = create(:company_profile)

    expect {
      PopulateJobPostingTableJob.perform_later('Software Engineer', '1000.00', 'USD', 'Mensal', 'Remoto', JobType.first,
                                                ExperienceLevel.first, company_profile.id)
    }.to have_enqueued_job
  end

  it 'is in default queue' do
    expect(PopulateJobPostingTableJob.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    expect(PopulateJobPostingTableJob.new).to respond_to(:perform
    ).with(8).arguments
  end

  it 'creates a new company profile' do
    job_type = create(:job_type, name: 'Full Time')
    experience_level = create(:experience_level, name: 'Junior')
    company_profile = create(:company_profile)

    expect {
      PopulateJobPostingTableJob.perform_now('Software Engineer', '1000.00', 'USD', 'Mensal', 'Remoto', job_type,
                                              experience_level, company_profile)
    }.to change(JobPosting, :count).by(1)

    job_posting = JobPosting.last
    expect(job_posting.title).to eq('Software Engineer')
    expect(job_posting.salary).to eq(1000.00)
    expect(job_posting.salary_currency).to eq('usd')
    expect(job_posting.salary_period).to eq('monthly')
    expect(job_posting.work_arrangement).to eq('remote')
  end
end
