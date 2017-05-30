# frozen_string_literal: true
module CachingHelper
  def current_user_cache_prefix
    user = current_user || :guest
    [Globalize.locale, user]
  end
end
