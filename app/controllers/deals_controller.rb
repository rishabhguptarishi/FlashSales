class DealsController < ApplicationController
  before_action :set_deal, only: [:show]
  def index
    @deals = Deal.live_deals.includes(:images)
  end


  def show
  end

  private def set_deal
    @deal = Deal.find(params[:id])
  end
end
