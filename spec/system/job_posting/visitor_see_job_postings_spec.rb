require 'rails_helper'

describe "Visitor sees job postings", type: :system do
  it "successfully" do
    # Arrange
    first_job_posting = create(:job_posting)
    second_job_posting = create(:job_posting)
    third_job_posting = create(:job_posting)
    # Act
    visit root_path
    # Assert
    expect(page).to have_content(first_job_posting.title)
    expect(page).to have_content(first_job_posting.company_profile.name)
    expect(page).to have_content(second_job_posting.title)
    expect(page).to have_content(third_job_posting.title)
  end
end
