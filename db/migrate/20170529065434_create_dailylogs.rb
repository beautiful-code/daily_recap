class CreateDailylogs < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_logs do |t|
      t.date :log_date
      t.string :takeaway
      t.string :user_id

      t.timestamps
    end
  end
end
