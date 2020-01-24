module Admin
  class DealsController < AdminController
    before_action :set_deal, only: [:show, :edit, :update, :check_publishable]

    def index
      @deals = Deal.all.includes(:images).page(params[:page])
      #FIXME_AB: paginated list
    end

    def show
    end

    def new
      @deal = Deal.new
      @deal.images.build
    end

    def create
      @deal = Deal.new(deal_params)
      @deal.create_deal_items
      respond_to do |format|
        if @deal.save
          format.html { redirect_to admin_deals_path, notice: "Deal has been saved and will go live at #{@deal.publish_at.to_date}" }
        else
          flash.now[:alert] = "Could not save deal, please fix errors below"
          if @deal.images.blank?
            @deal.images.build
          end
          format.html { render 'new' }
        end
      end
    end

    def edit
      @deal.images.build()
    end

    def update
      @deal.create_deal_items
      respond_to do |format|
        if @deal.update(deal_params)
          format.html { redirect_to admin_deals_path, notice: "Deal has been updated" }
        else
          format.html { render :edit }
        end
      end
    end

    def check_publishable
      response = @deal.can_be_published?
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
