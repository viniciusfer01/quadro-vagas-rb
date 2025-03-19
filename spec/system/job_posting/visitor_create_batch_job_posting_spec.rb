require 'rails_helper'

describe 'visitor create batch job posting', type: :system do
  it 'and has to be signed in' do
    visit root_path

    expect(page).not_to have_link 'Anunciar vagas em lote'
  end
end
