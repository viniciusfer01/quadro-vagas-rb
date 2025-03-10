require 'rails_helper'

describe 'Admin changes experience level status' do
  it 'sucefuly', type: :system, js: true  do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: :admin)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'
    sleep 2
    experience_level_first = ExperienceLevel.create(
      name: "Junior",
      status: :archived
    )

    visit experience_levels_path
    click_on "Ativar"

    expect(page).to have_content 'Junior'
    expect(page).to have_content 'Status: Ativo'
  end
end
