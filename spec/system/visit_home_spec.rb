require 'rails_helper'

describe 'Visit home page', type: :system, js: true do
  it 'successfully' do
    visit root_path

    expect(page).to have_content 'Hello world from Stimulus'
  end
end
