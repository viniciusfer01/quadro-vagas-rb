require 'rails_helper'

describe 'Registered user tries to access the page to create a company profile' do
  it 'but first, has to be signed in', type: :system do
    User.create!(email_address: 'my@email.com', password: 'strong123')
    visit root_path

    expect(page).not_to have_link 'Perfil da Empresa'
  end

  it 'and succeeds', type: :system, js: true do
    user = User.create!(email_address: 'my@email.com', password: 'strong123')
    visit root_path

    click_on 'Entrar'
    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: user.password
    within 'form' do
      click_on 'Sign in'
    end
    click_on 'Perfil da Empresa'
    click_on 'Criar Perfil de Empresa'
    fill_in 'Nome', with: 'BlinkedOn'
    fill_in 'URL do Site', with: 'https://blinkedon.tech'
    fill_in 'Email de Contato', with: 'contact@blinkedon.tech'
    attach_file 'Logo', Rails.root.join('spec', 'support', 'logo.png')
    click_on 'Create Perfil de Empresa'

    expect(current_path).to eq company_profiles_path
    expect(page).to have_content 'Perfil de Empresa criado com sucesso!'
    expect(page).to have_content 'Perfil da minha Empresa'
    company = CompanyProfile.last
    expect(page).to have_content "Nome: #{company.name}"
    expect(page).to have_content "Email de Contato: #{company.contact_email}"
    expect(page).to have_content "URL do Site: #{company.website_url}"
    expect(page).to have_content "URL do Site: #{company.website_url}"
    expect(page).to have_css('img[src*="logo.png"]')
  end
end
