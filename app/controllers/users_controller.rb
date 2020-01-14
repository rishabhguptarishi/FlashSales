class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  #FIXME_AB: I think we should not show other user's info to user. So lets authorize user on the show page and show his own record, instead of taking user_id from params, take it from current_user
  skip_before_action :authorize, except: [:show]

  # GET /users/new
  def new
    @user = User.new
  end

  def show
  end

  # POST /users
  # POST /users.json
  def create
    #FIXME_AB: User.customers.new . Use scopes
    @user = User.customers.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to login_url, notice: "Please confirm your email address to continue" }
      else
        format.html { render 'new', alert: "Ooooppss, something went wrong!" }
      end
    end
  end

  def confirm_email
    #FIXME_AB: ensure verification_token exists by before action
    user = User.find_by(verification_token: params[:token])
    if user && user.activate_account
      redirect_to login_url, notice: "Welcome to the Sample App! Your email has been confirmed.Please sign in to continue."
    else
      redirect_to login_url, alert: "Sorry. User does not exist"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = @current_user
      #FIXME_AB: what if user not found
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
