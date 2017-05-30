# frozen_string_literal: true
module Administrate
  class RansackSearch < Search
    def run
      q.result(distinct: true)
    end

    def q
      resource_class.ransack(term)
    end
  end
end
