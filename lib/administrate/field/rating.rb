# frozen_string_literal: true
require 'administrate/field/nested_has_one'
require 'administrate/page/form'
require 'rails'
require 'administrate/engine'

module Administrate
  module Field
    class Rating < NestedHasOne
    end
  end
end
