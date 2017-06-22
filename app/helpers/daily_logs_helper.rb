module DailyLogsHelper
  def build_query_hash(params)
    query_hash ={}
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
    query_hash

  end
end

