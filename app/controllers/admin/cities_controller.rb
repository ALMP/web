# frozen_string_literal: true
require 'administrate/ransack_search'

module Admin
  class CitiesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
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
        .select('cities.*')
        .from(resource_class.with_name.uniq, 'cities')
        .ransack(params[:q])
        .result
        .page(params[:page])
        .uniq
    end
  end
end
