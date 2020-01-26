module Admin
  class ReportsController < AdminController

    def total_revenue
      @deals = Deal.published.page(params[:page])
    end

    def maximum_potential
      @deals = Deal.published.page(params[:page])
    end

    def minimum_potential
      @deals = Deal.published.page(params[:page])
    end

    def top_spending_customers
      @users = User.all.page(params[:page])
    end

  end
end
