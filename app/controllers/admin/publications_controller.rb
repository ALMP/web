# frozen_string_literal: true
module Admin
  class PublicationsController < Admin::ApplicationController
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

    def approve
      requested_resource.status = :confirmed
      requested_resource.save
      respond_with namespace, requested_resource, location: request.referer
    end

    def decline
      requested_resource.status = :declined
      requested_resource.save
      respond_with namespace, requested_resource, location: request.referer
    end

    def search
      @_search ||= Administrate::RansackSearch.new(resource_resolver, params[:q])
    end

    def resources
      resource_class
        .ransack(params[:q])
        .result
        .page(params[:page])
        .includes(:company)
        .order(created_at: :desc)
    end
  end
end
