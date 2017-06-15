require 'rails_helper'

RSpec.describe LogEntry, type: :model do
 let(:entry) { FactoryGirl.build(:log_entry) }
   [:log_text, :project_id,:daily_log_id].each do |msg|
    it "should respond to #{msg}" do
      expect(entry).to respond_to(msg)
    end
  end
<<<<<<< HEAD
  it "should belongs to daily_log" do
    t = LogEntry.reflect_on_association(:daily_log)
    t.macro.should == :belongs_to
  end
  it "should belongs to project" do
    t = LogEntry.reflect_on_association(:project)
    t.macro.should == :belongs_to
  end

=======
>>>>>>> 3b127cb9e81258aac7731555728298c01f41f6d8
end
