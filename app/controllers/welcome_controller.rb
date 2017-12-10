class WelcomeController < ApplicationController
  def index
    @message = Message.new
    @messages = logged_in? ? Message.joins(:user).where(users: { admin: true }) : []
  end
end