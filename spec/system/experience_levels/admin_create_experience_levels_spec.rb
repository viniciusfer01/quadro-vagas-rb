require 'rails_helper'

describe 'Admin create experience level' do
  it 'succesfully', type: :system, js: true do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: 10)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'

    visit new_experience_level_path
    fill_in 'Nome', with: 'Junior'
    select 'Arquivado', from: 'Status'
    click_on 'Salvar'

    expect(page).to have_content 'Junior'
    expect(page).to have_content 'Status: Arquivado'
    expect(page).to have_content 'Editar'
    expect(page).to have_content 'Ativar'
  end

  it 'And creates a active experienced level', type: :system, js: true do
    user = User.create(email_address: 'user@email.com', password: '12345678', role: 10)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'

    visit new_experience_level_path
    fill_in 'Nome', with: 'Junior'
    select 'Ativo', from: 'Status'
    click_on 'Salvar'

    expect(page).to have_content 'Junior'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_content 'Editar'
    expect(page).to have_content 'Arquivar'
  end

  it 'fails with no name inputed', type: :system, js: true do 
    user = User.create(email_address: 'user@email.com', password: '12345678', role: 10)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'

    visit new_experience_level_path
    select 'Ativo', from: 'Status'
    click_on 'Salvar'

    expect(current_path).to eq new_experience_level_path
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'fails with no name inputed', type: :system, js: true do 
    user = User.create(email_address: 'user@email.com', password: '12345678', role: 10)
    visit new_session_path
    fill_in 'email_address', with: 'user@email.com'
    fill_in 'password', with: '12345678'
    click_on 'Sign in'

    experience_level_first = ExperienceLevel.create(
      name: "Junior",
      status: 0
    )

    visit new_experience_level_path
    fill_in 'Nome', with: 'Junior'
    select 'Ativo', from: 'Status'
    click_on 'Salvar'

    expect(current_path).to eq new_experience_level_path
    expect(page).to have_content 'Nome já está em uso'
  end
end
