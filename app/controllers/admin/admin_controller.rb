module Admin
  class AdminController < ApplicationController
    layout "admin"

    before_action :authorize_admin
    skip_before_action :set_order

    def authorize_admin
      unless current_user.is_admin?
        redirect_to root_path, alert: "You are not authorized to view this page"
      end
    end
  end
end
