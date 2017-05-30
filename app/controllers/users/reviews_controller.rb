# frozen_string_literal: true
module Users
  class ReviewsController < ApplicationController
    before_action :authenticate_user!

    def index
      @reviews = current_user.reviews.includes(:custom_rating).confirmed.page(params[:page]).order(created_at: :desc).per(10)
    end
  end
end
