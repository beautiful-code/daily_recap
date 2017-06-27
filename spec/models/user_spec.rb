require 'rails_helper'

RSpec.describe User, type: :model do

  describe :from_omniauth do
    it 'should get  user details from oauth after successful authentication' do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123',
        info: {
        name: 'dummy',
        email: 'dummy@dummy.com'
      },
      credentials: {
        token: 'dummy',
        expires_at: 123456
      }
      })

      before_user_count = User.count
      user = User.from_omniauth(OmniAuth.config.mock_auth[:google_oauth2])
      expect(user.provider).to eq('google_oauth2')
      expect(user.uid).to eq('123')
      expect(user.name).to eq('dummy')
      expect(user.email).to eq('dummy@dummy.com')
      expect(user.oauth_token).to eq('dummy')
      #expect(user.token_expires_at).to eq(123_456)


    end
  end
  it "should have many daily_logs" do
    association = User.reflect_on_association(:daily_logs)
    association.macro.should == :has_many
  end
  it "should have many and belongs to projects" do
    association = User.reflect_on_association(:projects)
    association.macro.should == :has_and_belongs_to_many
  end
  #context 'when newly created' do
  #it 'should return an empty collection for projects' do
  #User.joins(:project).where('id=?',user.id).count.should == 0
  #end
  #it 'should return an empty collection for daily_logs' do
  #User.joins(:daily_logs).where('id=?',user.id).count.should == 0
  #end
  ##expect(User.count).to eq(before_user_count+1)
  #end


    context 'when authentication fails' do
    # describe what happens when authentication fails.
  end

end





