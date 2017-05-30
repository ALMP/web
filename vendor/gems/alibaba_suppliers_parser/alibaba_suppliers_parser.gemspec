# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alibaba_suppliers_parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'alibaba_suppliers_parser'
  spec.version       = AlibabaSuppliersParser::VERSION
  spec.authors       = ['Sergey Kuchmistov']
  spec.email         = ['sergey.kuchmistov@gmail.com']

  spec.summary       = 'Alibaba suppliers parser'
  spec.description   = 'Scrape alibaba.com and save suppliers in redis'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'redis'
  spec.add_dependency 'mechanize'
  spec.add_dependency 'redis-queue'
  spec.add_dependency 'chrono_logger'
  spec.add_dependency 'parallel'
  spec.add_dependency 'commander'
  spec.add_dependency 'highline'
  spec.add_dependency 'terminal-table'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
