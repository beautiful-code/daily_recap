class DailyLogsController < ApplicationController
  include DailyLogsHelper
  skip_before_action :verify_authenticity_token
  def new
    if(current_user.nil?)
      url="/auth/google_oauth2"
      redirect_to(url)
    else
      #@projects=Project.where(client_name: Project::BEAUTIFUL_CODE_CLIENT)
      @daily_log =current_user.daily_logs.new
      @projects=Project.all
      #if(!params[:start_date].nil?)
        #session[:start_date] =params[:start_date]
        #session[:end_date]=params[:end_date]
      #end
      #if(params[:project_id].nil? != true )
        #if(params[:project_id].empty?)
          #session[:project_id]=nil
        #else
          #session[:project_id] =params[:project_id]
        #end
      #end

      query_hash = build_query_hash(params)
     # query_hash.merge!(user_id: current_user.id)
      #if(session[:start_date] != nil)
        #query_hash.merge!(log_date: session[:start_date]..session[:end_date])
      #else
        #query_hash.merge!(log_date: 1.week.ago..Date.today)
      #end
      #@user_log_summary=@daily_log.user_create_summary(query_hash,session[:project_id])
      if(params[:project_id].nil? or params[:project_id].empty?)
      @user_log_summary=DailyLog.new.user_create_summary(query_hash,nil)
    else
      @user_log_summary=DailyLog.new.user_create_summary(query_hash,params[:project_id])
    end

    end

  end

  def create
    if(DailyLog.where(user_id: current_user.id,log_date:params[:datetime_ida]).count==0)
      ActiveRecord::Base.transaction do
        daily_log=DailyLog.create(user_id: current_user.id,takeaway: params[:takeaway],log_date: params[:datetime_ida])
        params[:Log_entry].each do |project_id,log_texts|
          log_texts.each do |logtext|
            daily_log.log_entries.create(project_id:project_id.to_i,log_text:logtext)
          end
        end
        daily_log.log_entries.new.create_logentry(4,params[:LearningLog])
      end
      flash[:success]="Daily log recorded"
      redirect_to summary_path
    else
      #TODO handle case when records are not saved, show flash message
      flash[:info]= "You have already entered daily_log for this day"
      redirect_to new_daily_log_path
    end

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
    query_hash = build_query_hash(params)
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
    @daily_log_id=params[:log_id]

  end
  def finish_edit
    DailyLog.find_by_id(params[:daily_log_id]).update_records(params[:Logtext],params[:Learning_log],params[:takeaway])
    if(!params[:NewLogtext].nil?)
      params[:NewLogtext].each do |project_id,log_entries|
        log_entries.each do|logtext|
          DailyLog.find_by_id(params[:daily_log_id]).log_entries.create(project_id:project_id,log_text:logtext) 
        end
      end
    end
    redirect_to new_daily_log_path
  end

end

