class Project < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :log_entries , :class_name => 'LogEntry'
  accepts_nested_attributes_for :log_entries

  BEAUTIFUL_CODE_CLIENT = "BeautifulCode"
  SOJERN_CLIENT = "Sojern"
  LEARNING = "Learning"
end
