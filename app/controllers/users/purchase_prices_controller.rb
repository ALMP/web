module Users
  class PurchasePricesController < ApplicationController
    def index
      @purchase_prices = current_user.purchase_prices.confirmed.page(params[:page]).order(created_at: :desc).per(10)
    end
  end
end
