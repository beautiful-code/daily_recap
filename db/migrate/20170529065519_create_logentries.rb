class CreateLogentries < ActiveRecord::Migration[5.1]
  def change
    create_table :log_entries do |t|
      t.text :log_text
      t.string :project_id
      t.string :daily_log_id

      t.timestamps
    end
  end
end
