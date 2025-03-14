require 'rails_helper'

RSpec.describe PopulateCompanyProfileTableJob, type: :job do
  it 'queues the job' do
    expect {
      PopulateCompanyProfileTableJob.perform_later('Pamonha do Zezin', 'https://www.pamonhadozezin.com', 'contato@pamonhadozezin.com', 1)
    }.to have_enqueued_job
  end

  it 'is in default queue' do
    expect(PopulateCompanyProfileTableJob.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    expect(PopulateCompanyProfileTableJob.new).to respond_to(:perform
    ).with(4).arguments
  end

  it 'creates a new company profile' do
    user = create(:user)

    expect {
      PopulateCompanyProfileTableJob.perform_now('Pamonha do Zezin', 'https://www.pamonhadozezin.com', 'contato@pamonhadozezin.com', user.id)
    }.to change(CompanyProfile, :count).by(1)

    profile = CompanyProfile.last
    expect(profile.name).to eq('Pamonha do Zezin')
    expect(profile.website_url).to eq('https://www.pamonhadozezin.com')
    expect(profile.contact_email).to eq('contato@pamonhadozezin.com')
    expect(profile.logo).to be_attached
    expect(profile.user.name).to eq(user.name)
  end
end
