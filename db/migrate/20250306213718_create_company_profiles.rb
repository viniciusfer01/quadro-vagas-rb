class CreateCompanyProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :company_profiles do |t|
      t.string :name
      t.string :website_url
      t.string :contact_email

      t.timestamps
    end
  end
end
