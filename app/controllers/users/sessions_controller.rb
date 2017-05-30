# frozen_string_literal: true
module Users
  class SessionsController < Devise::SessionsController
    def set_flash_message!(type, key, options = {})
      # do nothing
    end

    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      session[:locale] = I18n.locale
      yield if block_given?
      respond_with resource, location: after_sign_out_path_for(resource_name)
    end
  end
end
