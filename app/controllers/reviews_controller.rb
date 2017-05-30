# frozen_string_literal: true
class ReviewsController < ApplicationController
  def index
    @company = Company.find params[:company_id]
    @presented_company = present @company
    @reviews = @company.reviews.confirmed.page(params[:page]).order(created_at: :desc).per(10)
  end

  def new
    @review = Review.new company_name: params[:company_name]
  end

  def create
    @review = Review.create review_params.merge(user: current_user)
    respond_with @review, location: review_redirect_path
  end

  protected

  def review_redirect_path
    if @review.company
      company_path(@review.company)
    else
      @review
    end
  end

  def review_params
    params.require(:review).permit(:name, :company_name, :terms_of_use_confirmed,
                                   :advantages, :disadvantages, :recommendations, :category,
                                   :thankful, :recommended, :quality, :payments, :service, :stability, :fairness,
                                   custom_rating_attributes: [:id, :title, :value, :_destroy])
  end
end
