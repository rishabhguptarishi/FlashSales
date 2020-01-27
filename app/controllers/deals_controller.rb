class DealsController < ApplicationController
  def index
    @deals = Deal.live_deals.includes(:images)
    unless @deals.any?
      @deals = Deal.past_deals.take(ENV['max_of_deals_for_a_day'].to_i)
    end
  end

  def get_availability
    deal = Deal.published.find(params[:id])
    #FIXME_AB: what if the deal not found in the above statement?
    respond_to do |format|
      format.json { render json: {quantity_available: deal.quantity_available?, live: deal.live} }
    end
  end


  def past_deals
    @deals = Deal.past_deals.page(params[:page])
  end
end
