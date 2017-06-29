class DailyLog < ApplicationRecord
  has_many :log_entries, :class_name => 'LogEntry',:dependent => :delete_all
  belongs_to :user
  validates :user_id, presence: true
  include ApplicationHelper

  #TODO create_user_summary would have been a better name
  #TODO golden rule: always space after a comma
  def self.user_create_summary(query_hash,project_id,log_date)
    #TODO project_id.present? is same as !project_id.nil?
    if(!project_id.nil? and !project_id.blank?)
      daily_logs= DailyLog.where(query_hash).joins(:log_entries).where(log_entries: {project_id: project_id}).order("log_date DESC").distinct
    else
      daily_logs=DailyLog.where(query_hash).order("log_date DESC")
    end
    #TODO query_hash.nil? will return false even if query_hash = {}, is your logic ok with this?
    if(query_hash.nil? and project_id.nil? and !log_date.nil? )
      daily_logs= DailyLog.where(log_date: log_date).order("log_date DESC")
    end
    daily_log_summary=Hash.new
    daily_logs.each_with_index do |daily_log,index|
      daily_log_summary[index] = daily_log.create_record(project_id)
    end
    daily_log_summary
  end

  #TODO create_summary_record would be better name
  def create_record(project_id)
    summary_record=Hash.new
    summary_record[:name] = self.user.name
    summary_record[:user_id] = self.user.id
    summary_record[:picture] = self.user.picture
    summary_record[:log_id] = self.id
    summary_record[:takeaway] = self.takeaway.to_s
    #TODO dont hard code client name values
    summary_record[:learning] = self.log_entries.where(project_id: Project.where(client_name: 'Learning').first.id).first.log_text
    summary_record[:beautifulcode] = beautifulcode_log_record(project_id)
    summary_record[:clients] = self.clients_project_log_record(project_id)
    summary_record[:logdate] = self.log_date.strftime('%v')
    byebug
    summary_record
  end

  def beautifulcode_log_record(project_id)
    #TODO change company_record name
    company_record={}
    #TODO why two conditions, project_id.present? should be fine right?
    if(!project_id.nil? and !project_id.blank?)
      project_log_ids = self.log_entries.joins(:project).where(projects:{id: project_id}).pluck(:id,:project_id)
    else
      project_log_ids=self.log_entries.joins(:project).where("projects.client_name='BeautifulCode'").pluck(:id,:project_id)
    end
    project_log_logtext = Hash.new{ |h,k| h[k] = [] }
    project_log_ids.each do |project_log_ids|
      #TODO why are you using find_by_id, when you have find()
      project_log_logtext[Project.find(project_log_ids[1]).name] <<[LogEntry.find_by_id(project_log_ids[0]).log_text,project_log_ids[0]]
    end
    project_log_logtext
  end

  def clients_project_log_record(project_id)
    #TODO dont hard code client names
    clients = Project.where.not(client_name: ['BeautifulCode', 'Learning']).distinct.pluck('client_name')
    #clients=Project.where.not(client_name: ['BeautifulCode', 'Learning']).pluck('distinct client_name')
    #TODO no semi colons please
    project_logs=Hash.new();
    clients.each do |client|
    #TODO why two conditions, project_id.present? should be fine right?
      ##TODO DONT repeat your code, DRY principle
      ##TODO combine beautifulcode_log_record and clients_project_log_record, we dont have to show any difference for them
      if(!project_id.nil? and !project_id.blank?)
        project_log_ids= self.log_entries.joins(:project).where(projects:{id: project_id, client_name:'#{client}' }).pluck(:id,:project_id)
      else
        project_log_ids=self.log_entries.joins(:project).where("projects.client_name='#{client}'").pluck(:id,:project_id)
      end
      project_log_logtext = Hash.new{|h,k| h[k] = []}
      project_log_ids.each do |x|
        project_log_logtext[Project.find_by_id(x[1]).name] <<[LogEntry.find_by_id(x[0]).log_text,x[0]]
      end
      project_logs[client.to_s]=project_log_logtext;
    end
    project_logs
  end

  def update_daily_log_and_log_entries(log_entry_records,learning,takeaway)
    log_entry_records.each do |project_id,log_entries|
      log_entries.each do|log_entry_id,log_text|
        self.log_entries.find(log_entry_id).update_attributes(project_id: project_id,log_text:log_text);
      end
    end
    self.update_attributes(:takeaway => takeaway)
    #TODO why are you hard coding project_id value 4
    ##TODO write a method in project model which return learning projects id
    self.log_entries.find_by_project_id(4).update_attributes(log_text: learning)
  end
  #TODO add empty line after each method
  def self.build_query_hash(params,current_user_id)
    query_hash ={}
    query_hash[:user_id] = params[:user_id] || current_user_id
    #TODO refactor below code
    if(!params[:start_date].nil?)
      query_hash.merge!(log_date: params[:start_date]..params[:end_date])
    else
      query_hash.merge!(log_date: 1.week.ago..Date.today)
    end
    query_hash
  end
end
