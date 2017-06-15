require 'rails_helper'
 
 RSpec.describe SessionsController, type: :controller do
   describe '#create' do
     it 'should create new user session' do
       user = User.create(name: 'dummy', email: 'dummy@dummy.com')
       allow(User).to receive(
         :from_omniauth
       ).and_return(user)
       post :create
       expect(session[:user_id]).to eq(user.id)
       expect(response).to redirect_to root_path
     end
    end
 
   describe '#destroy' do
     it 'should destroy user session' do
       delete :destroy
       expect(session[:user_id]).to eq(nil)
       expect(response).to redirect_to root_path
     end
   end
 
 end