require 'application_responder'

# frozen_string_literal: true
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include LocaleSupport
  protect_from_forgery with: :exception
end
