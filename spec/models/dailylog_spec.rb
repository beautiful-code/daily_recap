require 'rails_helper'
RSpec.describe DailyLog, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {User.create(name:"avinash",email:"avinash@beautifulcode.in")  }
  let(:daily_log) { FactoryGirl.build(:daily_log) }
  let(:log_entry) { FactoryGirl.build(:log_entry) }
  before do
    daily_log.user_id=user.id
    daily_log.save
    log_entry.daily_log_id=daily_log.id
    log_entry.save
  end

  [:log_date, :takeaway].each do |msg|
    it "should respond to #{msg}" do
      expect(daily_log).to respond_to(msg)
    end
  end

  it "should have many log_entries" do
    association = DailyLog.reflect_on_association(:log_entries)
    association.macro.should == :has_many

    expect(association.macro).to eq(:has_many)
  end

  it 'should belong to a user' do
    association = DailyLog.reflect_on_association(:user)
    #TODO refactor this
    association.macro.should == :belongs_to
  end

  it 'should have only one dailylog entry for given date for given user' do
    @dailylog = DailyLog.where(log_date: Date.today,user_id: 1)
    #expect(@dailylog.count). to be <= 1

    expect(@dailylog.count).to eq(1)
  end

  it 'should delete all associated log entries on deleting daily log' do
    #count = DailyLog.first.log_entries.count
    #total_count = LogEntry.all.count
    #DailyLog.first.destroy
    #expect(LogEntry.all.count).to equal(total_count - count)
    #count =daily_log.log_entries.count
    count=LogEntry.all.count
    expect(count).to eq(1)
  end
  describe 'validations' do
    it 'should have valid user_id' do
      daily_log.update_attributes(user_id: nil)
      expect(daily_log.errors).to include(:user_id)
    end

  end

  describe :user_create_summary do
    context "when project id is nil" do
      it "should return daily logs for als projects" do

      end
    end

    context "when project id is not nil" do

    end

    context "when project_id and query_hash are not present and log date is present" do

    end

  end

  describe :create_record do
    log=DailyLog.new
    query_hash={user_id: 1,log_date:1.week.ago..Date.today}
    before do
      log.id=1
      log.user_id = 1
      log.log_date=Date.today
      log.takeaway="need to improve"
      log.save
      allow(log).to receive(:beautifulcode_log_record).and_return nil
      allow(log).to receive(:clients_project_log_record).and_return nil
    end
    it 'should return formatted daily log record' do
      #:log_date = Date.today
      record = log.class.user_create_summary(query_hash,nil,nil)
      expect(record.keys).to match_array([:name, :takeaway, :learning, :beautifulcode, :clients])
      expect(record.keys).to match_array([:name])
    end
  end
end



