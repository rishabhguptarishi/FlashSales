module Admin
  class AdminController < ApplicationController
    before_action :authorize_admin

    def authorize_admin
      unless current_user.is_admin?
        redirect_to root_path(current_user.id), alert: "You are not authorized to view this page"
      end
    end
  end
end
