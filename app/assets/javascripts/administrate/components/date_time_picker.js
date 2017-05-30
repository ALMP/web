//= require datetime_picker

$(function () {
	
  $(".datetimepicker").datetimepicker({
    debug: false,
		locale: document.documentElement.lang,
    format: "YYYY-MM-DD hh:mm:ss",
  });
});
