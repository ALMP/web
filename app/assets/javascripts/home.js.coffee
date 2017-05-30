homePageResize = ->
  $wrapper = $(".search-form-wrapper", "body.pages.pages-index")
  return unless $wrapper[0]?

  totalHeight = $(".bg-image").height()
  currentHeight = $wrapper.height()
  topPadding = parseInt($wrapper.css('padding-top').slice(0, -2))

  diff = totalHeight - currentHeight - topPadding
  if diff < 0
    $(".companies-container").css('margin-top', "#{diff}px")
    diff = 0
  else
    $(".companies-container").css('margin-top', 0)

  $wrapper.css('padding-bottom', "#{diff}px")


$(document).on 'ready turbolinks:load', homePageResize
$(window).on 'resize', homePageResize

$(document).on 'ready turbolinks:load', -> 
  $('img').load homePageResize

$(document).on 'turbolinks:load', ->
  $('body').on 'click', '.advanced-search', ->
    console.log("clicked")
    $("#advancedSearch").toggle()
    homePageResize()
