module Api
  class ApiController < ApplicationController
    skip_before_action :authorize
    skip_before_action :set_order

  end
end
