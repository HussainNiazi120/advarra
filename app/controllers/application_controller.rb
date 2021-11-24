class ApplicationController < ActionController::Base
  before_action :authorize

  protected

  def authorize
    redirect_to root_url, alert: 'Please sign in first' unless User.find_by(id: session[:user_id])
  end
end
