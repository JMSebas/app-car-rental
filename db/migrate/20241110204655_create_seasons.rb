class CreateSeasons < ActiveRecord::Migration[7.2]
  def change
    create_table :seasons do |t|
      t.string :season
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
