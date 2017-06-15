class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.text :feedback_text
      t.string :user_id
      t.string :daily_log_id

      t.timestamps
    end
  end
end
