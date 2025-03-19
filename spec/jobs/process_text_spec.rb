require 'rails_helper'

RSpec.describe ProcessTxtJob, type: :job do
  it 'Open job' do
    file_path = Rails.root.join('spec/fixtures/job_postings.txt')
    ProcessTxtJob.perform_later(file_path.to_s)

    expect(enqueued_jobs.size).to eq(1)
  end

  it 'Job processes the lines' do
    user = create(:user)
    file_path = Rails.root.join('spec/fixtures/job_postings_job.txt')
    File.open(file_path, "w") do |file|
      file.puts "U,usuario2@example.com,Nome do usuario,sobrenome,password123"
      file.puts "E,Empresa A,https://www.empresa-a.com,contato@empresa-a.com,1"
      file.puts "V,Desenvolvedor Ruby on Rails,5000,BRL,Mensal,Presencial,1,São Paulo,1,1,descrição da vaga"
    end

    ProcessTxtJob.perform_later(file_path.to_s, user.id)
    perform_enqueued_jobs

    expect(enqueued_jobs.size).to eq(3)
  end
end
