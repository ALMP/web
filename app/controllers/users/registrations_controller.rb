# frozen_string_literal: true
module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: [:email, :password, :password_confirmation, :current_password, :recommendator])
    end

    def set_flash_message(type, key, options = {})
      # do nothing
    end

    def update_resource(resource, params)
      if resource.has_no_password?
        resource.update_without_password(params)
      else
        resource.update_with_password(params)
      end
    end
  end
end
