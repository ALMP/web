# frozen_string_literal: true
module Admin
  class CompanyAliasesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    helper_method :resource_class

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
        .ransack(params[:q])
        .result
        .includes(:company)
        .page(params[:page])
    end
  end
end
