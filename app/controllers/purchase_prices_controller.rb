# frozen_string_literal: true
class PurchasePricesController < ApplicationController
  def index
    @company = Company.find params[:company_id]
    @presented_company = present @company
    @purchase_prices = @company.purchase_prices.confirmed.page(params[:page]).order(created_at: :desc).per(10)
  end

  def new
    @purchase_price = PurchasePrice.new company_name: params[:company_name]
  end

  def create
    @purchase_price = PurchasePrice.create purchase_params.merge(user: current_user)
    respond_with @purchase_price, location: purchase_price_redirect_path
  end

  protected

  def purchase_price_redirect_path
    if @purchase_price.company
      company_path(@purchase_price.company)
    else
      @purchase_price
    end
  end

  def purchase_params
    params.require(:purchase_price).permit(:name, :value, :quantity, :unit, :kind, :company_name)
  end
end
