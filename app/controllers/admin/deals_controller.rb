module Admin
  class DealsController < AdminController
    before_action :set_deal, only: [:show, :edit, :update]
    def index
      @deals = Deal.all.includes(:images)
    end

    def show
    end

    def new
      @deal = Deal.new(publish_at: ENV['deal_publish_time'])
      @deal.images.build()
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
          flash.now[:alert] = "Could not save deal, please fix errors below"
          format.html { render 'new' }
        end
      end
    end

    def edit
      @deal.images.build()
    end

    def update
      if @deal.can_be_published?
        @deal.publishable = true
      end
      respond_to do |format|
        if @deal.update(deal_params)
          format.html { redirect_to admin_deals_path, notice: "Deal has been updated" }
        else
          format.html { render :edit }
        end
      end
    end

    def check_publishable
      deal = Deal.find_by(id: params[:id])
      response = deal.can_be_published?
      respond_to do |format|
        format.json { render json: response }
      end
    end

    private def set_deal
      @deal = Deal.find(params[:id])
    end

    private def deal_params
      params.require(:deal).permit(:title, :description, :price, :discounted_price, :quantity, :publish_at, images_attributes: [:id, :image, :_destroy])
    end
  end
end
