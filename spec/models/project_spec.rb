require 'rails_helper'

RSpec.describe Project, type: :model do
<<<<<<< HEAD
  let(:project) { FactoryGirl.build(:Project) }
  let(:id) { '111111' }
   [:name, :client_name].each do |msg|
=======
  let(:project) { FactoryGirl.build(:project) }

  [:name, :client_name].each do |msg|
>>>>>>> 3b127cb9e81258aac7731555728298c01f41f6d8
    it "should respond to #{msg}" do
      expect(project).to respond_to(msg)
    end
  end
<<<<<<< HEAD
  it "should have many users " do
    t = Project.reflect_on_association(:users)
    t.macro.should == :has_and_belongs_to_many
  end
  it "should have many log_entries" do
    t = Project.reflect_on_association(:log_entries)
    t.macro.should == :has_many
  end
  context 'when newly created' do
     it 'should not have any log entries' do
     	LogEntry.joins(:project).where("projects.id=1111").count.should == 0
     end
     it 'should not have any users' do
     	User.joins(:project).where("projects.id=1111").count.should == 0
     	
     end
  end


    #it 'should not have any users'
  end
=======

  it 'should have many users'

  it 'should have many log entries'

  context 'when newly created' do
    it 'should not have any log entries'

    it 'should not have any users'
  end
end
>>>>>>> 3b127cb9e81258aac7731555728298c01f41f6d8
