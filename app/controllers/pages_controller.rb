# frozen_string_literal: true
class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout :layout_for_page

  def index
    @q = Company.ransack(params[:q])
    @popular_companies = present_many Company.popular.limit(5)
    @new_companies = present_many Company.order('last_review_added desc nulls last').limit(5)
  end

  def layout_for_page
    case action_name
    when 'index'
      'application'
    else
      'static'
    end
  end
end
