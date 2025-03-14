require 'rails_helper'

RSpec.describe PopulateUserTableJob, type: :job do
  it 'queues the job' do
    expect { PopulateUserTableJob.perform_later('email@address.com', 'password', 'Zezin', 'da Pamonha', company_id: 1) }.to have_enqueued_job
  end

  it 'is in default queue' do
    expect(PopulateUserTableJob.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    expect(PopulateUserTableJob.new).to respond_to(:perform
    ).with(4).arguments
  end

  it 'creates a new user' do
    expect { PopulateUserTableJob.perform_now('email@address.com', 'password', 'Zezin', 'da Pamonha', company_id: 1) }.to change(User, :count).by(1)
  end
end
