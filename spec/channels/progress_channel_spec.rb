require 'rails_helper'

RSpec.describe ProgressChannel, type: :channel do
  it "subscribes to a stream" do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("progress_channel")
  end
end
