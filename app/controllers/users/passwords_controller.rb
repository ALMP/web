# frozen_string_literal: true
module Users
  class PasswordsController < Devise::PasswordsController
    def set_flash_message!(type, key)
      # do nothing
    end
  end
end
