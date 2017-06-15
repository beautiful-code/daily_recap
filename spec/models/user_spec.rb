require 'rails_helper'

RSpec.describe User, type: :model do

	describe :from_omniauth do
<<<<<<< HEAD
=======

>>>>>>> 3b127cb9e81258aac7731555728298c01f41f6d8
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
<<<<<<< HEAD
 
=======

      before_user_count = User.count

>>>>>>> 3b127cb9e81258aac7731555728298c01f41f6d8
      user = User.from_omniauth(OmniAuth.config.mock_auth[:google_oauth2])
      expect(user.provider).to eq('google_oauth2')
       expect(user.uid).to eq('123')
       expect(user.name).to eq('dummy')
       expect(user.email).to eq('dummy@dummy.com')
       expect(user.oauth_token).to eq('dummy')
       #expect(user.token_expires_at).to eq(123_456)
<<<<<<< HEAD
     end
   end
  it "should have many daily_logs" do
    t = User.reflect_on_association(:daily_logs)
    t.macro.should == :has_many
  end
  it "should have many and belongs to projects" do
    t = User.reflect_on_association(:projects)
    t.macro.should == :has_and_belongs_to_many
  end

  context 'when newly created' do
    it 'should return an empty collection for projects' do
      User.joins(:project).where('id=?',user.id).count.should == 0

    it 'should return an empty collection for daily_logs' do
       User.joins(:daily_logs).where('id=?',user.id).count.should == 0

  end
=======
       
       expect(User.count).to eq(before_user_count+1)
     end

    pending 'should not create a new user if the user already exists'

    context 'when authentication fails' do
      # describe what happens when authentication fails.
    end

   end

  it 'should have many projects'

  it 'should have many daily_logs'

  context 'when newly created' do
    it 'should return an empty collection for projects'
    it 'should return an empty collection for daily_logs'
  end


  #pending "add some examples to (or delete) #{__FILE__}"
>>>>>>> 3b127cb9e81258aac7731555728298c01f41f6d8
end

