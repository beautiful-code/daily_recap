class DailyLog < ApplicationRecord
  has_many :log_entries, :class_name => 'LogEntry',:dependent => :delete_all
  belongs_to :user
  include ApplicationHelper
  def user_create_summary(query_hash,project_id)
    if(!project_id.nil?)
      daily_logs= DailyLog.where(query_hash).joins(:log_entries).where("log_entries.project_id=#{project_id}")
    else
      daily_logs=DailyLog.where(query_hash)
    end
    log_summary=Hash.new
    daily_logs.each_with_index do |daily_log,index|
      summary_record=daily_log.create_record()
      log_summary[index]=summary_record
    end


    log_summary
  end

  def create_summary(log_date:)
    daily_logs= DailyLog.where(log_date: log_date)
    log_summary=Hash.new
    daily_logs.each_with_index do |daily_log,index|
      summary_record = daily_log.create_record()
      log_summary[index]=summary_record
    end
    log_summary
  end

  def create_record()

    summary_record=Hash.new
    summary_record[:name] = User.where("id=#{self.user_id}")[0].name;
    summary_record[:picture]= User.where("id=#{self.user_id}")[0].picture;
    summary_record[:log_id] = self.id;
    summary_record[:takeaway]=self.takeaway.to_s
    summary_record[:learning]= LogEntry.where(:daily_log_id => self.id).joins(:project).where("projects.client_name='Learning'")[0].log_text;
    summary_record[:beautifulcode]=self.company_record()
    summary_record[:clients] =self.client_record()
    summary_record[:logdate]=self.log_date.strftime('%v')
    summary_record
  end
  def company_record()
    company_record={}
    #TODO move where clauses to models instance methods
    #if(project_id != nil)
    #log_ids=LogEntry.where(:daily_log_id => self.id,:project_id => project_id).joins(:project).where("projects.client_name='BeautifulCode'").pluck(:id)
    #else
    log_ids=LogEntry.where(:daily_log_id => self.id).joins(:project).where("projects.client_name='BeautifulCode'").pluck(:id)
    #end
    log_ids.each do |log_id|
      company_record[LogEntry.find_by_id(log_id).project.name.to_s]=LogEntry.find_by_id(log_id).log_text.to_s;
    end
    company_record
  end
  def client_record()
    clients=Project.where.not(client_name: ['BeautifulCode', 'Learning']).pluck('distinct client_name')
    project_logs=Hash.new();
    clients.each do |client|
      #if(project_id !=nil)
      #project_log_ids=LogEntry.where(:daily_log_id => self.id,:project_id => project_id).joins(:project).where("projects.client_name='#{client}'").pluck(:id,:project_id)
      #else
      project_log_ids=LogEntry.where(:daily_log_id => self.id).joins(:project).where("projects.client_name='#{client}'").pluck(:id,:project_id)
      # end
      project_log_logtext=Hash.new()
      project_log_ids.each do |log_id,pid|
        project_log_logtext[Project.find_by_id(pid).name]=LogEntry.find_by_id(log_id).log_text;
      end
      project_logs[client.to_s]=project_log_logtext;
    end
    project_logs
  end
end
