class DailyLogsController < ApplicationController
  include DailyLogsHelper
  skip_before_action :verify_authenticity_token

  def new
    #TODO authencticate user in application controller
    if(current_user.nil?)
      url="/auth/google_oauth2"
      redirect_to(url)
    else
      @daily_log =current_user.daily_logs.new
      @projects=Project.all

      #TODO move my logs related code to index action
      query_hash = build_query_hash(params)
      #move this logic to model method, you are calling same method twice with diff params
      if(params[:project_id].nil? or params[:project_id].empty?)
        @user_log_summary=DailyLog.new.user_create_summary(query_hash,nil)
      else
        @user_log_summary=DailyLog.new.user_create_summary(query_hash,params[:project_id])
      end
    end
  end

  def create
    if(DailyLog.where(user_id: current_user.id,log_date:params[:datetime_ida]).count==0)
      begin
        ActiveRecord::Base.transaction do
          daily_log=DailyLog.create(user_id: current_user.id,takeaway: params[:takeaway],log_date: params[:datetime_ida])
          #TODO params should be in lower case, params[:log_entries]
          params[:Log_entry].each do |project_id,log_texts|
            log_texts.each do |logtext|
              daily_log.log_entries.create(project_id:project_id.to_i,log_text:logtext)
            end
          end
          #TODO params should be in lower case
          ##TODO add this to above log entries
          daily_log.log_entries.new.create(project_id: 4,log_text: params[:LearningLog])
        end
      rescue
        #TODO add flash error message and redirect to respective path
      end
      flash[:success]="Daily log record is successfully created"
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
    #TODO use lower case for instance variables
    @All_users=User.all;
  end
  #TODO add empty line after every action
  def refresh
    @log_summary=DailyLog.new.create_summary(log_date: params[:log_date])
    render :partial => "daily_logs/user_summary",object: @log_summary,locals: { log_summary: @log_summary}
  end
  def user_logs
    #TODO move build_query_hash helper method to model
    query_hash = build_query_hash(params)
    #same changes as mentioned in new action
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
    #TODO remove unnecessary empty lines

  end
  #TODO change this action name to update
  def finish_edit
    #TODO change naming for params
    DailyLog.find_by_id(params[:daily_log_id]).update_records(params[:Logtext],params[:Learning_log],params[:takeaway])
    if(!params[:NewLogtext].nil?)
      #TODO use proper naming
      params[:NewLogtext].each do |project_id,log_entries|
        log_entries.each do|logtext|
          DailyLog.find_by_id(params[:daily_log_id]).log_entries.create(project_id:project_id,log_text:logtext) 
        end
      end
    end
    #TODO handle negative case
    redirect_to new_daily_log_path
  end

end

