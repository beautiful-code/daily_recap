class DailyLogsController < ApplicationController
  include DailyLogsHelper
  skip_before_action :verify_authenticity_token
  def new
    #@projects=Project.where(client_name: Project::BEAUTIFUL_CODE_CLIENT)
    @daily_log =current_user.daily_logs.new
    @projects=Project.all
    if(!params[:start_date].nil?)
      session[:start_date] =params[:start_date]
      session[:end_date]=params[:end_date]
    end
    if(params[:project_id].nil? != true )
      if(params[:project_id].empty?)
        session[:project_id]=nil
      else
        session[:project_id] =params[:project_id]
      end
    end

    query_hash = {}
    query_hash.merge!(user_id: current_user.id)
    if(session[:start_date] != nil)
      query_hash.merge!(log_date: session[:start_date]..session[:end_date])
    else
      query_hash.merge!(log_date: 1.week.ago..Date.today)
    end
    @user_log_summary=@daily_log.user_create_summary(query_hash,session[:project_id])

  end

  def create
    ActiveRecord::Base.transaction do
      daily_log=DailyLog.create(user_id: current_user.id,takeaway: params[:takeaway],log_date: params[:datetime_ida])
      #count = 0
      #count2=1
      #byebug
      #while count<params[:projects].count do
      ##params[:projects].each_with_index do |key, index|
      #params[:projects][count2]["LogText"].each_with_index do |logtext|
      ##entry=LogEntry.new.create_logentry(params[:projects][count].to_i, logtext,daily_log.id)
      #daily_log.log_entries.new.create_logentry(params[:projects][count].to_i, logtext)
      #end
      #count =count+2;
      #count2=count2+2;
      #end
      params[:Log_entry].each do |project_id,log_texts|
        byebug
        log_texts.each do |logtext|
          byebug
          daily_log.log_entries.create(project_id:project_id.to_i,log_text:logtext)
          
        end
      end

      daily_log.log_entries.new.create_logentry(4,params[:LearningLog])
    end

    redirect_to summary_path
    #TODO handle case when records are not saved, show flash message
  end

  def index
  end

  #TODO change this action to index action
  def summary
    @log_summary=DailyLog.new.create_summary(log_date: Date.today)
  end

  def people_logs
    @log_summary=DailyLog.new.create_summary(log_date: Date.today)
    @All_users=User.all;
  end
  def refresh
    @log_summary=DailyLog.new.create_summary(log_date: params[:log_date])
    render :partial => "daily_logs/user_summary",object: @log_summary,locals: { log_summary: @log_summary}
  end
  def user_logs
    query_hash = {}
    if(!params[:user_id].nil?)
      query_hash.merge!(user_id: params[:user_id])
    else
      query_hash.merge!(user_id: current_user.id)
    end
    if(!params[:start_date].nil?)
      query_hash.merge!(log_date: params[:start_date]..params[:end_date])
    else
      query_hash.merge!(log_date: 1.week.ago..Date.today)
    end
    if(params[:project_id].nil? or params[:project_id].empty?)
      @user_logs=DailyLog.new.user_create_summary(query_hash,nil)
    else
      @user_logs=DailyLog.new.user_create_summary(query_hash,params[:project_id])
    end

    render :partial => "daily_logs/user_summary",object: @user_logs,locals: { log_summary: @user_logs}
  end
  def edit_log
    @edit_log = DailyLog.find(params[:log_id]).create_record();
    @projects=Project.all
  end

end
