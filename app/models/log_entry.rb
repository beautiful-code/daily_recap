class LogEntry < ApplicationRecord
	belongs_to :daily_log
	belongs_to :project

	#def create_logentry(project_id,logtext,daily_log_id)
	def create_logentry(project_id,logtext)
      LogEntry.create(project_id: project_id,log_text: logtext,daily_log_id: daily_log_id)
	end
end
