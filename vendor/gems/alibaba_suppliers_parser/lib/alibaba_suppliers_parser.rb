# frozen_string_literal: true
require 'alibaba_suppliers_parser/version'
require 'alibaba_suppliers_parser/showcase'
require 'alibaba_suppliers_parser/pages'
require 'alibaba_suppliers_parser/stat'
require 'alibaba_suppliers_parser/clear'

require 'alibaba_suppliers_parser/runner'

module AlibabaSuppliersParser
  require 'alibaba_suppliers_parser/railtie' if defined?(Rails)
end
