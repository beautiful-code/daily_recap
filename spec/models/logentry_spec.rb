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
    expect(association.macro).to eq(:belongs_to)
  end
  it "should belong to project" do
    association = LogEntry.reflect_on_association(:project)
    expect(association.macro).to eq(:belongs_to)
  end
  it "should have valid log_text" do

    expect(entry.log_text.to_s.length).to be > 0
  end
end
