class DealsController < ApplicationController
  before_action :set_deal, only: [:show]
  def index
    @deals = Deal.live_deals.includes(:images)
    unless @deals.any?
      @deals = Deal.past_deals.take(ENV['max_of_deals_for_a_day'].to_i)
    end
  end

  #FIXME_AB: get_availability
  def get_deal_quantity
    response = {}
    #FIXME_AB: Deal.published.find...
    deal = Deal.find(params[:id])
    #FIXME_AB: response['quantity_available'] = deal.quantity_available?
    response['quantity'] = deal.quantity_available?
    response['live'] = deal.live

    respond_to do |format|
      format.json { render json: response }
      #FIXME_AB: since it is a small hash so we can do this:
      # format.json { render json: {quantity_available: deal.quantity_available?, live: deal.live} }
      #FIXME_AB: or we can make a private method and call that here like below:
      #format.json { render json: deal_availability_object(deal) }
    end
  end


  def show
  end

  def past_deals
    @deals = Deal.past_deals.page(params[:page])
  end

  private def set_deal
    #FIXME_AB: what if object not found. Also we should ensure that use can see only published deals Deal.published.find...
    @deal = Deal.find(params[:id])
  end
end
