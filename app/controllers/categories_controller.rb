# frozen_string_literal: true
class CategoriesController < ApplicationController
  def show
    @q = Company.ransack(params[:q])
    @category = Category.find params[:id]
    @companies = @category.companies.page(params[:page])
  end

  def index
    @q = Company.ransack(params[:q])
    @categories = Category.all.order(companies_count: :desc).page(params[:page])
  end
end
