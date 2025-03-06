class CreateJobPostings < ActiveRecord::Migration[8.0]
  def change
    create_table :job_postings do |t|
      t.string :title
      t.references :company_profile, null: false, foreign_key: true
      t.string :salary
      t.string :salary_currency
      t.string :salary_period

      t.timestamps
    end
  end
end
