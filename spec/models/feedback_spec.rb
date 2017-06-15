require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:feedbackentry) { FactoryGirl.build(:feedback) }
   [:feedback_text, :user_id,:daily_log_id].each do |msg|
    it "should respond to #{msg}" do
      expect(feedbackentry).to respond_to(msg)
    end
  end
<<<<<<< HEAD
  it "should belongs to user" do
    t = Feedback.reflect_on_association(:user)
    t.macro.should == :belongs_to
  end
  it "should belongs to daily_log" do
    t = Feedback.reflect_on_association(:daily_log)
    t.macro.should == :belongs_to
  end
=======
>>>>>>> 3b127cb9e81258aac7731555728298c01f41f6d8
end
