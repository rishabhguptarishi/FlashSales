class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  skip_before_action :authorize, :set_order, except: [:show]
  before_action :ensure_token_exists, only: [:confirm_email]


  def new
    @user = Role.customer.users.new
  end

  def show
  end

  def create
    @user = Role.customer.users.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to login_url, notice: t('.confirm_email', email: @user.email) }
      else
        flash.now[:alert] = t('.alert')
        format.html { render 'new'  }
      end
    end
  end

  def confirm_email
    user = User.find_by(verification_token: params[:token])
    if user && user.activate_account!
      redirect_to login_url, notice: t('.notice', name: user.name)
    else
      redirect_to login_url, alert: t('.alert')
    end
  end

  private def ensure_token_exists
    if params[:token].blank?
      redirect_to login_url, alert: "Invalid token passed"
    end
  end
    # Use callbacks to share common setup or constraints between actions.
  private def set_user
    @user = current_user
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  private def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
