# frozen_string_literal: true
module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      sign_in resource if resource.confirmed?
      redirect_to after_confirmation_path_for(resource_name, resource)
    end

    def after_confirmation_path_for(_resource_name, _resource)
      root_path
    end
  end
end
