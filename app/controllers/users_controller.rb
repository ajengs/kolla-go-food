class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :topup, :save_topup]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'User was successfully created.'}
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
        format.html { redirect_to users_url, notice: 'User was successfully updated.'}
        format.json { render :show, status: :ok, location: @user }

        @users = User.all
        # ActionCable.server.broadcast 'users', html: render_to_string('store/index', layout: false)
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
  def topup
  end

  def save_topup
    # gopay = @user.gopay + topup_params[:gopay].to_i
    respond_to do |format|
      if @user.topup(topup_params[:gopay].to_i)
        @users = User.all
        format.html { redirect_to users_url, notice: "Topup was successfully updated" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :topup }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, role_ids: [])
    end

    def topup_params
      params.require(:user).permit(:gopay)
    end
end
