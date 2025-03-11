require 'rails_helper'

describe 'User tries to change the status of another user', type: :system do
  context 'as admin' do
    it 'and deactivate with succees' do
      user = create(:user)
      company = create(:company_profile, user: user)
      job_posting = create(:job_posting, company_profile: company)
      create(:user, email_address: 'admin@user.com', role: :admin)

      visit root_path
      click_on 'Entrar'
      fill_in 'email_address', with: 'admin@user.com'
      fill_in 'password', with: 'password123'
      click_button 'Sign in'

      visit user_path(user)
      click_on 'Desativar'

      expect(user.reload.status).to eq "inactive"
      expect(company.reload.status).to eq "inactive"
      expect(job_posting.reload.status).to eq "inactive"
      expect(current_path).to eq user_path(user)
      expect(page).to have_content 'Status alterado com sucesso.'
    end

    it 'and activate with succees' do
      user = create(:user, status: :inactive)
      company = create(:company_profile, status: :inactive, user: user)
      job_posting = create(:job_posting, status: :inactive, company_profile: company)
      create(:user, email_address: 'admin@user.com', role: :admin)

      visit root_path
      click_on 'Entrar'
      fill_in 'email_address', with: 'admin@user.com'
      fill_in 'password', with: 'password123'
      click_button 'Sign in'

      visit user_path(user)
      click_on 'Ativar'

      expect(user.reload.status).to eq "active"
      expect(company.reload.status).to eq "active"
      expect(job_posting.reload.status).to eq "active"
      expect(current_path).to eq user_path(user)
      expect(page).to have_content 'Status alterado com sucesso.'
    end
  end

  context 'as user' do
    it 'and fails because is not admin' do
      user = create(:user)
      create(:user, email_address: 'second@user.com')

      visit root_path
      click_on 'Entrar'
      fill_in 'email_address', with: 'second@user.com'
      fill_in 'password', with: 'password123'
      click_button 'Sign in'

      visit user_path(user)

      expect(page).not_to have_button 'Desativar'
      expect(page).not_to have_button 'Ativar'
    end
  end
end
