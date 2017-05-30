function translate_bing(text, to, target, success) {
  if(typeof(complete) != 'function')
    complete = function(){};
  jQuery.ajax({
    type: 'POST',
    url: '/translate',
    dataType: 'js',
    data: {
      'text': text.substr(0, 5000),
      'to': (to || window.navigator.language),
    },
    complete: success
  });
}

$(document).on("ready turbolinks:load", function() {
  $("body").on("click", ".js-translate", function() {
    var to = $('html').attr('lang');
    var $a = $(this);
    var target = $a.data('translatable');
    var text = $(target).text();
    var $spinner = $a.find('.spinner');
    $spinner.removeClass('d-none');
    translate_bing(text, to, target, function(response) {
      $a.remove();
      $(target).html(response.responseText);
    })
  });
});
