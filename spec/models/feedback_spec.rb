require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:feedback_entry) { FactoryGirl.build(:feedback) }
  [:feedback_text, :user_id,:daily_log_id].each do |msg|
    it "should respond to #{msg}" do
      expect(feedback_entry).to respond_to(msg)
    end
  end
  it "should belongs to user" do
    association = Feedback.reflect_on_association(:user)
    association.macro.should == :belongs_to
  end
  it "should belongs to daily_log" do
    association = Feedback.reflect_on_association(:daily_log)
    association.macro.should == :belongs_to
  end
end
