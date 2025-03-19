require 'rails_helper'

describe 'user see status of job', type: :system do
  it 'with success', js: true do
    user = create(:user, role: :admin)
    user_for_job = create(:user, email_address: 'usuario@email.com')
    company = create(:company_profile, user: user)
    job_type = create(:job_type)
    experience_level = create(:experience_level)
    Rails.root.join('spec', 'fixtures', 'job_postings.txt')
    arrayLine = [ "U,usuario2@example.com,Nome do usuario,sobrenome,password123", "E,Empresa A,https://www.empresa-a.com,contato@empresa-a.com,#{user_for_job.id}",
                  "V,Desenvolvedor Ruby on Rails,5000,BRL,Mensal,Presencial, #{job_type.id},São Paulo,#{experience_level.id},#{company.id},descrição da vaga" ]
    redis = Redis.new(url: ENV["REDIS_URL"])
    redis.set("job-data-user-#{user.id}-processed-lines", "0")
    redis.set("job-data-user-#{user.id}-remaining-lines", arrayLine.length)
    redis.set("job-data-user-#{user.id}-successful-registrations", "0")
    redis.set("job-data-user-#{user.id}-lines-error", "0")
    redis.set("job-data-user-#{user.id}-lines-error-list", [].to_json)

    login_as(user)
    visit job_batch_index_path
    arrayLine.each_with_index { |line, index| BatchImportJob.perform_now(line, user.id, index) }

    expect(current_path).to eq(job_batch_index_path)
    expect(page).to have_content('Linhas Processados: 3')
    expect(page).to have_content('Registrados com Sucesso: 3')
    expect(page).to have_content('Linhas com Erro: 0')
    expect(page).to have_content('Linhas Restantes: 0', normalize_ws: true)
  end
end
