require 'rails_helper'

RSpec.describe "HomePages", type: :request do
  describe "GET /index" do
    it 'ensures home page is rendered correctly' do
      get root_url
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Home Page')
    end
  end
end
