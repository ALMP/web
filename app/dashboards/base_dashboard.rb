# frozen_string_literal: true
require 'administrate/base_dashboard'

class BaseDashboard < Administrate::BaseDashboard
  def sort_ransacker_for(field)
    sort_ransackers[field]
  end

  def sortable?(field)
    sort_ransacker_for(field).present?
  end

  def search_attribute
    :name_cont
  end
end
