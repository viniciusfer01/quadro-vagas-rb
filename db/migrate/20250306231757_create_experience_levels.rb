class CreateExperienceLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :experience_levels do |t|
      t.string :name

      t.timestamps
    end
  end
end
