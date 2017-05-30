# frozen_string_literal: true
class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # Redirects resources to the collection path (index action) instead
  # of the resource path (show action) for POST/PUT/DELETE requests.
  # include Responders::CollectionResponder
  #
  # Add locals variablse to error response
  def navigation_behavior(error)
    locals = options.delete(:locals) || {}
    if has_errors? && default_action
      render action: default_action, locals: locals
    else
      super
    end
  end
end
