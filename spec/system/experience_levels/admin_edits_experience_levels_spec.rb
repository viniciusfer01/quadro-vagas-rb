require 'rails_helper'

describe 'Admin edit experience level' do
  it 'and must be logged in', type: :system, js: true do
    experience_level = ExperienceLevel.create(
      name: "Junior",
      status: :archived
    )

    visit edit_experience_level_path(experience_level.id)

    expect(current_path).to eq new_session_path
  end

  it 'and user must be admin', type: :system, js: true do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: :regular)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'
    sleep 2
    experience_level = ExperienceLevel.create(
      name: "Junior",
      status: :archived
    )

    visit edit_experience_level_path(experience_level.id)

    expect(current_path).to eq root_path
  end

  it 'succesfully', type: :system, js: true do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: :admin)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'

    ExperienceLevel.create(
      name: "Junior",
      status: :archived
    )

    visit experience_levels_path
    click_on 'Editar'
    fill_in 'Nome', with: 'Pleno'
    click_on 'Salvar'

    expect(page).to have_content 'Pleno'
    expect(page).to have_content 'Status: Arquivado'
    expect(page).to have_content 'Editar'
    expect(page).to have_content 'Ativar'
  end

  it 'fail when name is empty', type: :system, js: true do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: :admin)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'

    ExperienceLevel.create(
      name: "Junior",
      status: :archived
    )

    visit experience_levels_path
    click_on 'Editar'
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'fails when name is repeated', type: :system, js: true do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: :admin)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'
    ExperienceLevel.create(
      name: "Junior",
      status: :archived
    )
    experience_level_second = ExperienceLevel.create(
      name: "Pleno",
      status: :archived
    )

    visit experience_levels_path
    within "#experience_level_#{experience_level_second.id}" do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Junior'
    click_on 'Salvar'

    expect(page).to have_content 'Nome já está em uso'
  end
end
