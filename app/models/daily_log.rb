class DailyLog < ApplicationRecord
  has_many :log_entries, :class_name => 'LogEntry', :dependent => :delete_all
  belongs_to :user
  validates :user_id, presence: true
  #TODO add a custom validation so that for a given user on a given log_date there should not be more than one record
  ##TODO you have logic to restrict this in create action but restriction at model level would be better option
  include ApplicationHelper

  def self.create_user_summary(params,user_id, project_id, log_date)
    #TODO use single line if statements when line length is small
    #if(params.present?)
     # query_hash = DailyLog.build_query_hash(params,user_id)
    #end
    query_hash = DailyLog.build_query_hash(params,user_id) if params.present?
    if( project_id.present? )
      #TODO query_hash will be undefined when params.present? will return false so it raises error
      daily_logs = DailyLog.where(query_hash).joins(:log_entries).where(log_entries: {project_id: project_id}).order("log_date DESC").distinct
    else
      daily_logs = DailyLog.where(query_hash).order("log_date DESC")
    end
    #TODO why are you doing query_hash.nil? it always returns false or error when params.present? is false
    ##TODO refactor this if condition and above if condition, use if elsif elsif end
    if(query_hash.nil? and project_id.nil? and !log_date.nil? )
      daily_logs = DailyLog.where(log_date: log_date).order("log_date DESC")
    end
    daily_log_summary = Hash.new
    daily_logs.each_with_index do |daily_log,index|
      daily_log_summary[index] = daily_log.create_summary_record(project_id)
    end
    daily_log_summary
  end

  def create_summary_record(project_id)
    summary_record=Hash.new
    summary_record[:name] = self.user.name
    summary_record[:user_id] = self.user.id
    summary_record[:picture] = self.user.picture
    summary_record[:log_id] = self.id
    summary_record[:takeaway] = self.takeaway.to_s
    #TODO dont hard code client name values
    #TODO why are not using Project.where(client_name: 'Learning').first.id
      summary_record[:learning]= self.log_entries.where(project_id:Project.where(client_name:'Learning')).first.log_text
   # summary_record[:learning] = self.log_entries.where(project_id: Project.where(client_name: 'Learning').first.id).first.log_text
    summary_record[:clients] = self.clients_project_log_record(project_id)
    summary_record[:logdate] = self.log_date.strftime('%v')
    summary_record
  end

  def clients_project_log_record(project_id)
    #TODO dont hard code client names
    clients = Project.where.not(client_name: 'Learning').distinct.pluck('client_name')
    project_logs = Hash.new()
    clients.each do |client|
      if( project_id.present? )
        project_log_ids = self.log_entries.joins(:project).where(projects:{id: project_id, client_name:"#{client}" }).pluck(:id,:project_id)
      else
        project_log_ids = self.log_entries.joins(:project).where("projects.client_name='#{client}'").pluck(:id,:project_id)
      end
      project_log_logtext = Hash.new{|h,k| h[k] = []}
      project_log_ids.each do |project_id_log_id|
        #TODO how many should I tell you to use find, that would be enough
        ##TODO add space before/after = << or any other operator
        project_log_logtext[Project.find_by_id(project_id_log_id[1]).name] <<[LogEntry.find_by_id(project_id_log_id[0]).log_text,project_id_log_id[0]]
      end
      project_logs[client.to_s]=project_log_logtext
    end
    project_logs
  end

  def update_daily_log_and_log_entries(log_entry_records,learning,takeaway)
    log_entry_records.each do |project_id,log_entries|
      log_entries.each do |log_entry_id,log_text|
        self.log_entries.find(log_entry_id).update_attributes(project_id: project_id, log_text:log_text);
      end
    end
    self.update_attributes(:takeaway => takeaway)
    #TODO dnt hard code values
    learning_project_id = Project.where(name: 'Learning').pluck(:id).first.to_i 
    self.log_entries.find_by_project_id(learning_project_id).update_attributes(log_text: learning)
  end

  def self.build_query_hash(params, current_user_id)
    query_hash ={}
    query_hash[:user_id] = params[:user_id] || current_user_id
    if(params[:start_date].present?)
      query_hash.merge!(log_date: params[:start_date]..params[:end_date])
    else
      query_hash.merge!(log_date: 1.week.ago.strftime('%v')..Date.today.strftime('%v'))
    end
    query_hash
  end

end
