require 'rails_helper'

RSpec.describe LogEntry, type: :model do
  let(:entry) { FactoryGirl.build(:log_entry) }
  [:log_text, :project_id,:daily_log_id].each do |msg|
    it "should respond to #{msg}" do
      expect(entry).to respond_to(msg)
    end
  end

  it "should belongs to daily_log" do
    association = LogEntry.reflect_on_association(:daily_log)
    association.macro.should == :belongs_to
  end
  it "should belongs to project" do
    association = LogEntry.reflect_on_association(:project)
    association.macro.should == :belongs_to
  end

end
