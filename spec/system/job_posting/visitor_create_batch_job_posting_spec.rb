require 'rails_helper'

describe 'visitor create batch job posting', type: :system do
  it 'and has to be signed in' do
    visit root_path

    expect(page).not_to have_link 'Anunciar vagas em lote'
  end

  it 'successfully', js: true do
    user = create(:user)
    create(:company_profile, user: user)
    JobType.create!(name: 'Part time')
    ExperienceLevel.create!(name: 'Junior', status: :active)

    login_as user

    visit root_path

    click_on 'Anunciar vagas em lote'
    attach_file 'Arquivo', Rails.root.join('spec/fixtures/job_postings.csv')
    click_on 'Enviar'

    expect(page).to have_content 'Waiting for import...'

    # Wait for the TurboStream update
    expect(page).to have_content 'Import completed', wait: 10

    expect(page).to have_content 'Desenvolvedor backend'
    expect(page).to have_content 'BlinkedOn'
    expect(page).to have_content 'Part time'
  end
end
