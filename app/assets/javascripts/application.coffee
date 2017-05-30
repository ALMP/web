#= require jquery
#= require jquery_ujs
#= require tether
#= require bootstrap-sprockets
#= require jquery.raty-fa
#= require jquery_nested_form
#= require turbolinks
#= require twitter/typeahead
#= require select2
#= require select2_locale_ru
#= require select2_locale_zh-CN
#= require select2_inputs
#= require localeSelect
#= require flashes
#= require stickyfill
#= require tooltipster.bundle
#= require percircle
#= require readmore
#= require rrssb
#= require jquery.unveil
#
#= require home
#= require autocomplete
#= require stars
#= require tooltips
#= require companies
#= require purchase_prices
#= require translate
#= require forms

$(document).on 'turbolinks:load', ->
  $('.sticky').Stickyfill()

  $('.percircle').percircle()

  $('.readmore').readmore
    speed: 75

  $('.rrssb-buttons').rrssb
    url:'http://'+ location.hostname

  $('img.lazy').unveil(200)
