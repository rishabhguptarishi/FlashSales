module Admin
  class UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all_except(current_user).page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_path, notice: "User #{@user.name} was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      unless @user
        redirect_to admin_deals_path, alert: 'User doesnt exist'
      end
    end

    private def user_params
      params.require(:user).permit(:name, :email)
    end
  end
end
