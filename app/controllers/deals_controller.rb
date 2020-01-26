class DealsController < ApplicationController
  def index
    @deals = Deal.live_deals.includes(:images)
    unless @deals.any?
      @deals = Deal.past_deals.take(ENV['max_of_deals_for_a_day'].to_i)
    end
  end

  def get_deal_quantity
    response = {}
    deal = Deal.find(params[:id])
    response['quantity'] = deal.quantity_available?
    response['live'] = deal.live
    respond_to do |format|
      format.json { render json: response }
    end
  end


  def past_deals
    @deals = Deal.past_deals.page(params[:page])
  end

  private def set_deal
    @deal = Deal.find(params[:id])
  end
end
