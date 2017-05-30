# frozen_string_literal: true
class GoodsController < ApplicationController
  def show
    @q = Company.ransack(params[:q])
    @good = Good.find params[:id]
    @companies = @good.companies.order(name: :asc).page(params[:page])
  end
end
