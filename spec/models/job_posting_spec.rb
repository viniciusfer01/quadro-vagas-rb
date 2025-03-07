require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  context "#Valid?" do
    it "fails when title is nil" do
      job_posting = build(:job_posting, title: nil)
      job_posting.valid?
      expect(job_posting).not_to be_valid
    end

    it "fails when salary is nil" do
      job_posting = build(:job_posting, salary: nil)
      job_posting.valid?
      expect(job_posting).not_to be_valid
    end

    it "fails when salary_currency is nil" do
      job_posting = build(:job_posting, salary_currency: nil)
      job_posting.valid?
      expect(job_posting).not_to be_valid
    end

    it "fails when salary_period is nil" do
      job_posting = build(:job_posting, salary_period: nil)
      job_posting.valid?
      expect(job_posting).not_to be_valid
    end
  end
end
