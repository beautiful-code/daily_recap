module DailyLogsHelper
  #TODO move this code to model search method
  def build_query_hash(params)
    query_hash ={}
    query_hash[:user_id] = params[:user_id] || current_user.id
    #TODO refactor below code
    if(!params[:start_date].nil?)
      query_hash.merge!(log_date: params[:start_date]..params[:end_date])
    else
      query_hash.merge!(log_date: 1.week.ago..Date.today)
    end
    query_hash

  end
end

