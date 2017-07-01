class DailyLogsController < ApplicationController
  include DailyLogsHelper
  skip_before_action :verify_authenticity_token
  before_action  :authenticate_user, :except=>[:index]

  def new
    @daily_log = current_user.daily_logs.new
    @projects = Project.where("name !='"+Project::LEARNING+"'") 
    @user_log_summary = DailyLog.create_user_summary(params,current_user.id, params[:project_id],log_date:nil)
  end

  def create
    if(DailyLog.check_log_entry_exists(current_user.id,params[:datetime_ida]))
      begin
        ActiveRecord::Base.transaction do
          daily_log = current_user.daily_logs.create(takeaway: params[:takeaway],log_date: params[:datetime_ida])
          params[:log_entry].each do |project_id,log_texts|
            log_texts.each do |logtext|
              daily_log.log_entries.create(project_id:project_id.to_i,log_text:logtext)
            end
          end
        end
      rescue
        flash[:info] = "Error occured,please try again"
        redirect_to new_daily_log_path
      end
      flash[:success] = "Daily log record is successfully created"
      redirect_to new_daily_log_path
    else
      flash[:info] = "You have already entered daily_log for this day"
      redirect_to new_daily_log_path
    end
  end

  def index
  end

  def people_logs
    @log_summary = DailyLog.create_user_summary(nil, nil, nil,Date.today)
    @all_users = User.all;
  end

  def refresh
    @log_summary = DailyLog.create_user_summary(nil,nil,nil, params[:log_date])
    render :partial => "daily_logs/user_summary",locals: { log_summary: @log_summary}
  end

  def user_logs
    @user_logs = DailyLog.create_user_summary(params,current_user.id,params[:project_id],nil) 
    render :partial => "daily_logs/user_summary",locals: { log_summary: @user_logs}
  end

  def edit_log
    @edit_log = DailyLog.find(params[:daily_log_id]).create_summary_record(nil)
    @projects = Project.where("name !='"+Project::LEARNING+"'")
    @daily_log_id = params[:daily_log_id]
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        DailyLog.find(params[:daily_log_id]).update_daily_log_and_log_entries(params[:log_entries],params[:learning_log],params[:takeaway],params[:new_log_entries])
      end
      flash[:info] = "Updated successfully"
      redirect_to new_daily_log_path
    rescue
      flash[:info] = "Update failed,Please try again"
      redirect_to new_daily_log_path
    end
  end
end

