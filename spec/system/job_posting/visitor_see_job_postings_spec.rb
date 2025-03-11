require 'rails_helper'

describe "Visitor sees job postings", type: :system do
  it "successfully" do
    rubyoncloud = CompanyProfile.create!(name: "Ruby on cloud", website_url: "http://rubyoncloud.com", contact_email: "contact@rubyoncloud.com")
    full_time_job = JobType.create!(name: "full time")
    junior = ExperienceLevel.create!(name: "junior")

    JobPosting.create!(title: "Dev Rails", company_profile: rubyoncloud, salary: "1000.00", salary_currency: :usd, salary_period: :monthly, job_type: full_time_job, experience_level: junior, work_arrangement: :remote, description: "Software Developer")
    second_job_posting = create(:job_posting)
    third_job_posting = create(:job_posting)

    visit root_path

    expect(page).to have_content("Dev Rails")
    expect(page).to have_content("Ruby on cloud")
    expect(page).to have_content("full time")
    expect(page).to have_content(second_job_posting.title)
    expect(page).to have_content(second_job_posting.company_profile.name)
    expect(page).to have_content(second_job_posting.job_type.name)
    expect(page).to have_content(third_job_posting.title)
    expect(page).to have_content(third_job_posting.company_profile.name)
    expect(page).to have_content(third_job_posting.job_type.name)
    expect(page).not_to have_content("Nenhuma vaga disponível no momento.")
  end

  it "and there are no job postings" do
    visit root_path

    expect(page).to have_content("Nenhuma vaga disponível no momento.")
  end
end
