class Feedback < ApplicationRecord
	belongs_to :user
	belongs_to :daily_log
end
