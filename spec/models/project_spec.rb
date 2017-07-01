require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.create(:project) }
  [:name, :client_name].each do |msg|
    it "should respond to #{msg}" do
      expect(project).to respond_to(msg)
    end
  end

  it "should have many users " do
    association = Project.reflect_on_association(:users)
    association.macro.should == :has_and_belongs_to_many
  end
  it "should have many log_entries" do
    association = Project.reflect_on_association(:log_entries)
    association.macro.should == :has_many
  end

  context 'when newly created' do
    it 'should not have any log entries' do
      count =  project.log_entries.count
      expect(count).to eq(0)
    end
  end

end



