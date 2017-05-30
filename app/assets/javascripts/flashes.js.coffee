$(document).on 'ready turbolinks:load', ->
  $('body').on 'click', '.flashes .close', -> $(@).parent().hide()
