$(document).on 'turbolinks:load', ->
  $('.tooltipster', '.review, .company').tooltipster
    theme: 'fairpard'
    side: 'bottom'
    functionPosition: (instance, helper, position) ->
      return position
