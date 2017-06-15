require 'rails_helper'
RSpec.describe DailyLog, type: :model do
  let(:daily_log) { FactoryGirl.build(:daily_log) }
   [:log_date, :takeaway].each do |msg|
    it "should respond to #{msg}" do
      expect(daily_log).to respond_to(msg)
    end
  end

   it 'should belong to a user'

   it 'should have many log_entries'



  # describe :record_create do
  #   before do
  #     daily_log.user_id = user.id
  #     daily_log.save
  #     allow(daily_log).to receive(:company_record).and_return nil
  #     allow(daily_log).to receive(:client_record).and_return nil
  #   end
  #    it 'should return formatted daily log record' do
  #      record = daily_log.record_create
  #     #expect(record.keys).to match_array([:name, :takeaway, :learning, :beautifulcode, :clients])
  #     #expect(record.keys).to match_array([:name])
  #    end
  # end
end



