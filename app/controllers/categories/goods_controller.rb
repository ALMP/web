# frozen_string_literal: true
class Categories::GoodsController < ApplicationController
  def index
    @q = Company.ransack(params[:q])
    @category = Category.find(params[:category_id])
    @goods = @category.goods.order(companies_count: :desc).page(params[:page])
  end
end
