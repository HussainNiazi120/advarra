require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:example) do
    @user = create(:user)
  end
  describe "GET /show" do
    it 'ensures user page is displayed successfully' do
      post sessions_url(user_name: 'Hussain', password: 'correctPassword')
      get user_url
      expect(response.body).to include('Hello Hussain!')
    end

    it 'ensures user is redirected to home page if they are not signed in' do
      get user_url
      expect(response).to redirect_to(root_url)
      follow_redirect!
      expect(response.body).to include('Please sign in first')
    end
  end
end
