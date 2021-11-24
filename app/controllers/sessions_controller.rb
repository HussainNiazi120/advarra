class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  def new

  end

  def create
    user = User.find_by(user_name: params[:user_name]) 
    if user&.locked
      redirect_to new_session_url, alert: 'Your account has been locked. It can only be unlocked by database administrator.'
    elsif user&.authenticate(params[:password])
      session[:user_id] = user.id
      user.update(attempts: 0)
      redirect_to user_url, alert: 'You have successfully signed in'
    else
      if user
        update_attempts(user) 
        attempts_msg = "Attempts #{user.attempts}/3"
      end
      redirect_to new_session_url, alert: "Invalid user name and password combination. #{attempts_msg}"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, alert: 'Signed out'
  end

  private

  def update_attempts(user)
      user.attempts += 1
      user.locked = true if user.attempts > 2
      user.save
  end
end
