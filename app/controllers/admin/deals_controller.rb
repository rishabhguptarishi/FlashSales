module Admin
  class DealsController < AdminController
    before_action :set_deal, only: [:show, :edit, :update]
    def index
      @deals = Deal.all
    end

    def show
    end

    def new
      @deal = Deal.new(publish_at: ENV['deal_publish_time'])
    end

    def create
      @deal = Deal.new(deal_params)
      if @deal.can_be_published?
        @deal.publishable = true
      end
      respond_to do |format|
        if @deal.save
          format.html { redirect_to admin_deals_path, notice: "Deal has been generated will go live at #{@deal.publish_at.to_date}" }
        else
          format.html { render 'new', alert: "Ooooppss, something went wrong!" }
        end
      end
    end

    def edit
    end

    def update
      if @deal.can_be_published?
        @deal.publishable = true
      end
      respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_deals_path, notice: "Deal has been updated" }
      else
        format.html { render :edit }
      end
    end
    end

    private def set_deal
      @deal = Deal.find(params[:id])
    end

    private def deal_params
      params.require(:deal).permit(:title, :description, :price, :discounted_price, :quantity, :publish_at, images: [])
    end
  end
end
