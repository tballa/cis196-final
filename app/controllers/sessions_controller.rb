class SessionsController < ApplicationController
  # GET /sessions/new
  def new
    @user = User.new
  end

  # POST /sessions
  # POST /sessions.json
  def create
    user = User.find_by(email: params[:email])
    if user && user.password == params[:password]
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to '/login'
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    reset_session
    redirect_to root_path
  end
end