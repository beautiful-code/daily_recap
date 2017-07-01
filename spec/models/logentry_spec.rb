require 'rails_helper'

RSpec.describe LogEntry, type: :model do
  let(:entry) { FactoryGirl.build(:log_entry) }
  [:log_text, :project_id,:daily_log_id].each do |msg|
    it "should respond to #{msg}" do
      expect(entry).to respond_to(msg)
    end
  end

  it "should belong to daily_log" do
    association = LogEntry.reflect_on_association(:daily_log)
    #TODO reafctor all expect statements like below one
    #association.macro.should == :belongs_to
    expect(association.macro).to eq(:belongs_to)
  end
  #TODO add empty line each test case
  it "should belong to project" do
    association = LogEntry.reflect_on_association(:project)
    association.macro.should == :belongs_to
  end
  it "should have valid log_text" do
    #TODO fill this

  end
end
