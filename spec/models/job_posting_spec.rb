require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  context "#Valid?" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:salary) }
    it { should validate_presence_of(:salary_currency) }
    it { should validate_presence_of(:salary_period) }
    it { should validate_presence_of(:job_type) }
    it { should belong_to :company_profile }
    it { should belong_to :job_type }
    it { should validate_presence_of(:description) }
  end

  context 'enum' do
    it { should define_enum_for(:status).with_values(active: 0, inactive: 1) }

    it "has default status as active" do
      jobposting = JobPosting.new
      expect(jobposting.status).to eq("active")
    end
  end
end
