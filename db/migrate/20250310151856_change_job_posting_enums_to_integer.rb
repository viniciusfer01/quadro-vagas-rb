class ChangeJobPostingEnumsToInteger < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        # Map existing string values to integers
        execute <<-SQL
          UPDATE job_postings
          SET salary_currency = CASE salary_currency
            WHEN 'USD' THEN 1
            WHEN 'EUR' THEN 2
            WHEN 'GBP' THEN 3
            ELSE 0
          END,
          salary_period = CASE salary_period
            WHEN 'monthly' THEN 1
            WHEN 'yearly' THEN 2
            ELSE 0
          END,
          work_arrangement = CASE work_arrangement
            WHEN 'remote' THEN 1
            WHEN 'onsite' THEN 2
            WHEN 'hybrid' THEN 3
            ELSE 0
          END
        SQL
      end
    end

    change_column :job_postings, :salary_currency, :integer, using: 'salary_currency::integer'
    change_column :job_postings, :salary_period, :integer, using: 'salary_period::integer'
    change_column :job_postings, :work_arrangement, :integer, using: 'work_arrangement::integer'
  end
end
