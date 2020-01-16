module Admin
  class DealsController < AdminController
    before_action :set_deal, only: [:show, :edit, :update]

    def index
      @deals = Deal.all.includes(:images)
      #FIXME_AB: paginated list
    end

    def show
    end

    def new
      #FIXME_AB: fix
      @deal = Deal.new(publish_at: ENV['deal_publish_time'])
      #FIXME_AB: no need for () if no  arguments passed to build
      @deal.images.build()
    end

    def create
      @deal = Deal.new(deal_params)

      #FIXME_AB: this should be after save callback

      if @deal.can_be_published?
        @deal.publishable = true
      end

      respond_to do |format|
        if @deal.save
          format.html { redirect_to admin_deals_path, notice: "Deal has been saved and will go live at #{@deal.publish_at.to_date}" }
        else
          flash.now[:alert] = "Ooooppss, something went wrong!"
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
      #FIXME_AB: before action
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
