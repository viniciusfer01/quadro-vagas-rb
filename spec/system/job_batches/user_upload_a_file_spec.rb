require 'rails_helper'

describe 'user send a file', type: :system do
  it 'and see the status' do
    user = create(:user, role: :admin)
    redis = Redis.new(url: ENV["REDIS_URL"])
    redis.set("job-data-user-#{user.id}-lines-error-list", [].to_json)

    login_as(user)
    visit root_path
    click_on 'Anunciar vagas em lote'
    attach_file 'upload', Rails.root.join('spec/fixtures/job_postings.txt')
    click_on 'Enviar'

    expect(current_path).to eq(batch_status_path)
    expect(page).to have_content('Tela de status')
  end

  it 'with success' do
    user = create(:user, role: :admin)
    redis = Redis.new(url: ENV["REDIS_URL"])
    redis.set("job-data-user-#{user.id}-lines-error-list", [].to_json)

    login_as(user)
    visit root_path
    click_on 'Anunciar vagas em lote'
    attach_file 'upload', Rails.root.join('spec/fixtures/job_postings.txt')
    click_on 'Enviar'

    expect(current_path).to eq(batch_status_path)
    expect(page).to have_content('Arquivo recebido com sucesso.')
  end

  it 'with nothing', js: true do
    user = create(:user, role: :admin)

    login_as(user)
    visit root_path
    click_on 'Anunciar vagas em lote'
    click_on 'Enviar'

    expect(current_path).to eq(new_job_batch_path)
    expect(page).to have_content('É necessário enviar um arquivo.')
  end

  it 'with an invalid file type', js: true do
    user = create(:user, role: :admin)

    login_as(user)
    visit root_path
    click_on 'Anunciar vagas em lote'
    attach_file 'upload', Rails.root.join('spec/support/files/logo.jpeg')
    click_on 'Enviar'

    expect(current_path).to eq(new_job_batch_path)
    expect(page).to have_content('O tipo do arquivo não é aceito.')
  end

  it 'but it is not authenticated' do
    visit new_job_batch_path

    expect(current_path).to eq(new_session_path)
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Forgot password?')
  end

  it 'but not an admin' do
    user = create(:user)

    login_as(user)
    visit new_job_batch_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Essa página não existe.')
  end
end
