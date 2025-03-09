require 'rails_helper'

describe 'Admin view experience levels list' do
  it 'succesfully', type: :system, js: true  do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: 10)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'
    experience_level_first = ExperienceLevel.create(
      name: "Junior",
      status: :archived
    )
    experience_level_first = ExperienceLevel.create(
      name: "Pleno",
      status: :active
    )

    visit experience_levels_path

    expect(page).to have_content 'Junior'
    expect(page).to have_content 'Status: Arquivado'
    expect(page).to have_content 'Pleno'
    expect(page).to have_content 'Status: Ativo'
  end

  it 'and there is no experience level', type: :system, js: true  do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: 10)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'

    visit experience_levels_path

    expect(page).to have_content 'Não há nìveis de experiência cadastradados'
  end
end