$(document).on("ready turbolinks:load", function() {
  $("#localeSwitcher").on("change", function() {
    var selected = this.options[this.options.selectedIndex]
    if (selected["host"]) {
      location.hostname = this.options[this.options.selectedIndex].dataset["host"]
    } else {
      location.href = this.options[this.options.selectedIndex].dataset["url"]
    }
  });
});
