require 'rails_helper'

describe "Visitor sees job postings", type: :system do
  it "successfully" do
    first_job_posting = create(:job_posting)
    second_job_posting = create(:job_posting)
    third_job_posting = create(:job_posting)

    visit root_path

    expect(page).to have_content(first_job_posting.title)
    expect(page).to have_content(first_job_posting.company_profile.name)
    expect(page).to have_content(first_job_posting.job_type.name)
    expect(page).to have_content(second_job_posting.title)
    expect(page).to have_content(second_job_posting.company_profile.name)
    expect(page).to have_content(second_job_posting.job_type.name)
    expect(page).to have_content(third_job_posting.title)
    expect(page).to have_content(third_job_posting.company_profile.name)
    expect(page).to have_content(third_job_posting.job_type.name)
    expect(page).not_to have_content("There are no job postings available right now.")
  end

  it "and there are no job postings" do
    visit root_path

    expect(page).to have_content("There are no job postings available right now.")
  end
end
