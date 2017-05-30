$(document).on 'ready turbolinks:load', ->
  $(".stars-fa").raty
    space: false
    readOnly: true
    score: ->  $(@).data('score')

  $(".stars-input").raty
    space: false
    redOnly: false
    targetType: 'score'
    targetKeep: true
    target: -> $(@).data 'target'
    score: -> $(@).data 'score'
