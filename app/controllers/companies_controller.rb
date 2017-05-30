# frozen_string_literal: true
class CompaniesController < ApplicationController
  def create
    @company = Company.create company_params
    respond_with @company, location: company_location
  end

  def new
    @company = Company.new name: params[:company_name]
  end

  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result.page(params[:page]).includes(:last_review, city: :translations).per(10)
    @presented_companies = present_many @companies
  end

  def show
    @company = Company.find params[:id]
    @presented_company = present @company
  end

  private

  def company_location
    if cookies[:company_redirect_to]
      cookies.delete :company_redirect_to
    else
      if @company.valid?
        company_path(@company)
      else
        new_company_path
      end
    end
  end

  def company_params
    params
      .require(:company)
      .permit(:name, :url, :email, :phone, :city_id, :address, :description,
              category_ids: [],
              good_ids: [])
  end
end
