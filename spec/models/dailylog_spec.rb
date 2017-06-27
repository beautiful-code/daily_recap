require 'rails_helper'
RSpec.describe DailyLog, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:daily_log) { FactoryGirl.build(:daily_log) }
   [:log_date, :takeaway].each do |msg|
    it "should respond to #{msg}" do
      expect(daily_log).to respond_to(msg)
    end
  end

  it "should have many log_entries" do
    association = DailyLog.reflect_on_association(:log_entries)
    association.macro.should == :has_many
  end
  it 'should belong to a user' do
     association = DailyLog.reflect_on_association(:user)
    association.macro.should == :belongs_to
  end
  # describe :create_record do
  #   log=DailyLog.new
  #   before do
  #     log.id=1111
  #     log.user_id = 1
  #     log.log_date=Date.today
  #     log.takeaway="need to improve"
  #     log.save
  #     allow(log.class).to receive(:company_record).and_return nil
  #     allow(log.class).to receive(:client_record).and_return nil
  #   end
  #    it 'should return formatted daily log record' do
  #     #:log_date = Date.today
  #      record = log.create_summary
  #     expect(record.keys).to match_array([:name, :takeaway, :learning, :beautifulcode, :clients])
  #     expect(record.keys).to match_array([:name])
  #    end
  # end
end



