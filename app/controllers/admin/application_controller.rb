# frozen_string_literal: true
require 'application_responder'
require 'administrate/ransack_search'

module Admin
  class ApplicationController < Administrate::ApplicationController
    self.responder = ApplicationResponder
    respond_to :html

    include LocaleSupport

    before_action :authenticate_admin

    add_flash_types :success, :error

    def update
      requested_resource.update resource_params
      respond_with namespace, requested_resource,
                   locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) }
    end

    def create
      resource = resource_class.create resource_params
      respond_with namespace, resource,
                   locals: { page: Administrate::Page::Form.new(dashboard, resource) }
    end

    def destroy
      requested_resource.destroy
      respond_with namespace, requested_resource
    end

    def authenticate_admin
      authenticate_user!
      redirect_to new_user_session_path unless current_user.admin?
    end

    def translate_with_resource(key)
      t(
        "administrate.controller.#{controller_name}.#{key}"
      )
    end

    def dashboard
      super
    end

    def search_term
      params.dig :q, dashboard.search_attribute
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
