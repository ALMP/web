# frozen_string_literal: true
require 'administrate/ransack_order'
require 'administrate/ransack_search'

module Admin
  class CompaniesController < Admin::ApplicationController
    def index
      page = Administrate::Page::Collection.new(dashboard, order: order)
      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        q: search.q
      }
    end

    def search
      @_search ||= Administrate::RansackSearch.new(resource_resolver, params[:q])
    end

    def resources
      resource_class
        .select('companies.*')
        .from(resource_class.with_city_name.uniq, 'companies')
        .ransack(params[:q])
        .result
        .joins(:aggregated_rating)
        .includes(categories: [:translations], city: [:translations], goods: [:translations])
        .page(params[:page])
        .uniq
    end
  end
end
