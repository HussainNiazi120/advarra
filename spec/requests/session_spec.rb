require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it 'ensures page is accessible by guest user' do
      get new_session_url
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Enter login information')
    end
  end

  describe "POST /create" do
    before(:example) do
      @user = create(:user)
    end
    
    it 'ensures successful login on correct credentials' do
      post sessions_url(user_name: 'Hussain', password: 'correctPassword')
      expect(response).to redirect_to(user_path)
    end

    it 'ensures error message incase of invalid username' do
      post sessions_url(user_name: 'John', password: 'anyPassword')
      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include('Invalid user name and password combination.')
    end

    it 'ensures error message incase of valid username but invalid password' do
      post sessions_url(user_name: 'Hussain', password: 'wrongPassword')
      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include('Invalid user name and password combination. Attempts 1/3')
    end

    it 'ensures user is able to sign in after 2 unsuccessful attempts and their attempts are reset to 0' do
      2.times do
        post sessions_url(user_name: 'Hussain', password: 'wrongPassword')
      end
      @user.reload
      expect(@user.attempts).to eq(2)
      post sessions_url(user_name: 'Hussain', password: 'correctPassword')
      @user.reload
      expect(@user.attempts).to eq(0)
      follow_redirect!
      expect(response.body).to include('You have successfully signed in')
    end

    it 'ensures account is locked on 3 unsuccessful attempts' do
      3.times do
        post sessions_url(user_name: 'Hussain', password: 'wrongPassword')
      end
      @user.reload
      expect(@user.locked).to be true
      post sessions_url(user_name: 'Hussain', password: 'wrongPassword')
      follow_redirect!
      expect(response.body).to include('Your account has been locked. It can only be unlocked by database administrator.')
    end
  end

  describe "DELETE /destroy" do
    before(:example) do
      @user = create(:user)
      post sessions_url(user_name: 'Hussain', password: 'correctPassword')
    end

    it 'ensures user is successfully signed out' do
      follow_redirect!
      delete session_url(@user.id)
      expect(response).to redirect_to(root_url)
      follow_redirect!
      expect(response.body).to include('Signed out')
    end
  end

end
