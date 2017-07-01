require 'rails_helper'
RSpec.describe DailyLog, type: :model do
  let(:user) {User.create(name:"avinash",email:"avinash@beautifulcode.in")  }
  let(:daily_log) { FactoryGirl.build(:daily_log) }
  let(:log_entry) { FactoryGirl.build(:log_entry) }
  let(:project) { FactoryGirl.create(:project) }
  let(:learning_project) { FactoryGirl.build(:project) }
  let(:learning) { FactoryGirl.build(:log_entry) }
  let(:revdirect) { FactoryGirl.build(:project) }
  let(:revdirect_log_entry) { FactoryGirl.build(:log_entry) }
  before do
    daily_log.user_id=user.id
    daily_log.save
    log_entry.daily_log_id=daily_log.id
    log_entry.project_id=project.id
    log_entry.save
    #TODO learning_project = Project.create(name: "Learning", client_name: "Learning")
    learning_project.name="Learning"
    learning_project.client_name="Learning"
    learning_project.save
    learning.daily_log_id=daily_log.id
    learning.project_id=learning_project.id
    learning.log_text ="advanced jquery"
    learning.save
    #TODO chnage this same as above one
    revdirect.name="revdirect"
    revdirect.client_name="Sojern"
    revdirect.save
    revdirect_log_entry.log_text ="solved ticket 3"
    revdirect_log_entry.project_id =revdirect.id
    revdirect_log_entry.daily_log_id=daily_log.id
    revdirect_log_entry.save
  end

  [:log_date, :takeaway].each do |msg|
    it "should respond to #{msg}" do
      expect(daily_log).to respond_to(msg)
    end
  end

  it "should have many log_entries" do
    association = DailyLog.reflect_on_association(:log_entries)

    expect(association.macro).to eq(:has_many)
  end

  it 'should belong to a user' do
    association = DailyLog.reflect_on_association(:user)

    expect(association.macro).to eq(:belongs_to)
  end

  it 'should have  one or none  dailylog entry for given date for given user' do
    @dailylog = DailyLog.where(log_date: Date.today,user_id: 1)

    expect(@dailylog.count).to be <= 1
  end

  it 'should delete all associated log entries on deleting daily log' do
    count =daily_log.log_entries.count
    total_count =LogEntry.all.count
    daily_log.destroy

    #TODO instead you can check expect(daily_log.log_entries.count).to eq(0)
    expect(LogEntry.all.count).to eq(total_count-count)
  end

  describe 'validations' do
    it 'should have valid user_id' do
      daily_log.update_attributes(user_id: nil)

      expect(daily_log.errors).to include(:user_id)
    end
    #TODO when you add custom validation to restrict one daily_log record per user per given date add specs for it

  end

  #TODO it should be create_user_summary
  describe :user_create_summary do
    #TODO when params.present? if false write case for it
    context "when project id is nil" do
      it "should return daily logs for all projects" do
        params= { user_id: user.id }
        records = daily_log.class.create_user_summary(params,nil,nil,nil)

        expect(records.values.first[:clients].values.first.keys).to match_array(["macnator","revdirect"])
      end
    end
    context "when project id is not nil" do
      it "should return daily_logs for specific project" do
        params ={user_id: user.id}
        records= daily_log.class.create_user_summary(params,nil,revdirect.id,nil)

        expect(records.values.first[:clients].values.first.keys).to match_array(["revdirect"])
      end
    end
    context "when project_id and query_hash are not present and log date is present" do
     it "should return daily logs of all users for that particular date" do
       records= daily_log.class.create_user_summary(nil,nil,nil,Date.today)

        expect(records.values.first[:logdate]).to eq(Date.today.strftime('%v'))
     end
    end
  end

  describe :create_summary_record do
    before do
      #TODO instead of returning nil return what sample data of what that method actually should return
      allow(daily_log).to receive(:clients_project_log_record).and_return nil
    end
    it 'should return formatted daily log record' do
      record = daily_log.create_summary_record(nil)

      expect(record.keys).to match_array([:name, :takeaway, :learning,:clients,:log_id,:logdate,:picture,:user_id])
    end
  end
  #TODO add empty line after every block
  ##TODO write specs for methods in the same order as written in model file
  describe :build_query_hash do 
    context "when date filter applied" do
      it "should return valid hash" do
        params = { user_id: 1, start_date: '25-07-2017',end_date: '30-07-2017' }
        query_hash = daily_log.class.build_query_hash(params,nil)

        expect(query_hash.keys).to match_array([:user_id,:log_date])
        expect(query_hash.values[1]).to eq("25-07-2017".."30-07-2017")
      end
    end
    context "when date filter not applied" do
      it "should return valid hash" do 
        params={ user_id: 1 }
        query_hash= daily_log.class.build_query_hash(params,nil) 
        value= 1.week.ago.strftime('%v')..Date.today.strftime('%v')

        expect(query_hash.keys).to match_array([:user_id,:log_date])
        expect(query_hash.values[1]).to eq(value)
      end
    end
  end

  describe :clients_project_log_record do
    context "when project filter not applied" do
      it "should return all project log entries" do
        record =daily_log.clients_project_log_record(nil)
        expect(record.values.first.keys).to match_array(["macnator","revdirect"])
      end
    end
    context "when project filter applied" do
      it "should return project specific log entries" do
        record =daily_log.clients_project_log_record(revdirect.id)
        expect(record.values.first.keys).to match_array(["revdirect"])
      end
    end
    #TODO add a case to test that record.values.first.keys not to include "learning"
  end
end



