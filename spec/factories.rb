FactoryGirl.define do
  factory :user do
    name "John"
    uid "1"
    email "abhipatnala@gmail.com"
    provider "google"
  end
  factory :daily_log do
    log_date '2017-05-31'
    takeaway 'spend more time on learning'
    user_id '1'
  end
  factory :log_entry do 
    log_text "done with views"
    project_id "2"
  end
  factory :project do
    name "revdirect"
    client_name "Sojern"
  end
  factory :feedback do
    feedback_text "good job"
    user_id "2"
    daily_log_id "2"
  end
end
