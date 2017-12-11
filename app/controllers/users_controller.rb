class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :reinstate_player, :view_target]

  def index
    @users = User.all
  end

  def show
    @message = Message.new
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.password = user_params[:password]
    @user.active = true
    @user.admin = false
    respond_to do |format|
      if @user.save
        format.html { redirect_to '/login', notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def takedown_target
    if logged_in?
      if admin?
        target = User.find(params[:id])
        current_user.takedown_target(target)
        Message.where(user: target).destroy_all
        redirect_to '/takeover_disputes'
      else
        target = User.find_by(name: current_user.target)
        current_user.takedown_target(target)
        redirect_to '/target_taken_down'
      end
    else
      redirect_to root_path
    end
  end

  def reinstate_player
    if logged_in? && admin?
      target = User.find(params[:id])
      current_user.reinstate_player(target)
      Message.where(user: target).destroy_all
      redirect_to '/takeover_disputes'
    else
      redirect_to root_path
    end
  end

  def update_pairings
    if logged_in? && admin?
      User.eliminate_inactive_players
      User.pair_users
    else
      redirect_to root_path
    end
  end

  def takeover_disputes
    redirect_to root_path unless logged_in?
  end

  def dispute_takeover
    redirect_to root_path unless logged_in?
    set_messages
  end

  def target_taken_down
    redirect_to root_path unless logged_in?
    set_messages
  end

  def view_target
    current_user.view_target
  end

  def posts
    redirect_to root_path unless logged_in?
    set_messages
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :admin, :target)
  end

  def set_messages
    @message = Message.new
    @messages = logged_in? ? Message.joins(:user).where(users: { admin: true }) : []
  end
end
