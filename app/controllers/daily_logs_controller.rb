class DailyLogsController < ApplicationController
  include DailyLogsHelper
  skip_before_action :verify_authenticity_token
  before_action  :authenticate_user, :except=>[:index]

  def new
    @daily_log =current_user.daily_logs.new
    @projects=Project.all
    #TODO call build_query_hash in user_create_summary method itself
    query_hash = DailyLog.build_query_hash(params,current_user.id)
    #TODO empty space before and after =
    @user_log_summary=DailyLog.user_create_summary(query_hash,params[:project_id],nil)
  end

  def create
    if(DailyLog.where(user_id: current_user.id,log_date:params[:datetime_ida]).count==0)
      begin
        ActiveRecord::Base.transaction do
          #TODO which one do you think is better?
          daily_log = current_user.daily_logs.create(takeaway: params[:takeaway],log_date: params[:datetime_ida])
          #daily_log=DailyLog.create(user_id: current_user.id,takeaway: params[:takeaway],log_date: params[:datetime_ida])
          params[:log_entry].each do |project_id,log_texts|
            log_texts.each do |logtext|
              daily_log.log_entries.create(project_id:project_id.to_i,log_text:logtext)
            end
          end
        end
      rescue
        #TODO it should be flash[:error]
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

  def people_logs
    @log_summary=DailyLog.user_create_summary(nil,nil,Date.today)
    @all_users=User.all;
  end

  def refresh
    @log_summary=DailyLog.user_create_summary(nil,nil, params[:log_date])
    #TODO why are you sending log_summary twice
    render :partial => "daily_logs/user_summary",object: @log_summary,locals: { log_summary: @log_summary}
  end

  def user_logs
    #TODO call build_query_hash in user_create_summary method itself
    query_hash = DailyLog.build_query_hash(params,current_user.id)
    @user_logs=DailyLog.user_create_summary(query_hash,params[:project_id],nil)
    #TODO why are you sending user_logs twice
    render :partial => "daily_logs/user_summary",object: @user_logs,locals: { log_summary: @user_logs}
  end

  def edit_log
    #TODO params should be params[:daily_log_id]
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
              #TODO no find_by_id, use find
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

