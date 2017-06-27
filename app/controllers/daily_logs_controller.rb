class DailyLogsController < ApplicationController
  include DailyLogsHelper
  skip_before_action :verify_authenticity_token
  before_action  :authenticate_user, :except=>[:index]

  def new
    @daily_log =current_user.daily_logs.new
    @projects=Project.all
    query_hash = DailyLog.build_query_hash(params,current_user.id)
    @user_log_summary=DailyLog.user_create_summary(query_hash,params[:project_id],nil)
  end

  def create
    if(DailyLog.where(user_id: current_user.id,log_date:params[:datetime_ida]).count==0)
      begin
        ActiveRecord::Base.transaction do
          daily_log=DailyLog.create(user_id: current_user.id,takeaway: params[:takeaway],log_date: params[:datetime_ida])
          params[:log_entry].each do |project_id,log_texts|
            log_texts.each do |logtext|
              daily_log.log_entries.create(project_id:project_id.to_i,log_text:logtext)
            end
          end
        end
      rescue
        flash[:info]= "Error occured,please try again"
        redirect_to new_daily_log_path
      end
      flash[:success]="Daily log record is successfully created"
      redirect_to new_daily_log_path
    else
      flash[:info]= "You have already entered daily_log for this day"
      redirect_to new_daily_log_path
    end
  end

  def index
  end

  #TODO change this action to index action

  def people_logs
    @log_summary=DailyLog.user_create_summary(nil,nil,Date.today)
    @all_users=User.all;
  end

  def refresh
    @log_summary=DailyLog.user_create_summary(nil,nil, params[:log_date])
    render :partial => "daily_logs/user_summary",object: @log_summary,locals: { log_summary: @log_summary}
  end

  def user_logs
    query_hash = DailyLog.build_query_hash(params,current_user.id)
    @user_logs=DailyLog.user_create_summary(query_hash,params[:project_id],nil)
    render :partial => "daily_logs/user_summary",object: @user_logs,locals: { log_summary: @user_logs}
  end

  def edit_log
    @edit_log = DailyLog.find(params[:log_id]).create_record(nil)
    @projects=Project.all
    @daily_log_id=params[:log_id]
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        DailyLog.find(params[:daily_log_id]).update_daily_log_and_log_entries(params[:log_entries],params[:learning_log],params[:takeaway])
        if(!params[:new_log_entries].nil?)
          params[:new_log_entries].each do |project_id,log_entries|
            log_entries.each do|logtext|
              DailyLog.find_by_id(params[:daily_log_id]).log_entries.create(project_id:project_id,log_text:logtext) 
            end
          end
        end
      end
    rescue
      flash[:info] = "Update failed,Please try again"
      redirect_to new_daily_log_path
    end
    flash[:info] = "Updated successfully"
    redirect_to new_daily_log_path
  end
end

