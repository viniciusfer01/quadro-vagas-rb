require 'rails_helper'

describe 'Admin create experience level', type: :system, js: true do
  it 'succesfully' do
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
end
