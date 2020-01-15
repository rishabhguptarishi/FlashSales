module Admin
  class UsersController < AdminController
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all_except(current_user).page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
  end
end
