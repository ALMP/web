//= require_self

$(document).on("ready turbolinks:load", function() {
  $(".select2").select2({
    theme: 'default',
    width: '100%',
    escapeMarkup: function(markup) {
      return markup;
    },
    templateSelection: function(item) {
      return item.text || item.name;
    },
    templateResult: function(item) {
      return item.name;
    },
    minimumInputLength: 2,
    allowClear: true,
    placeholder: function() {
      return {
        id: ''
      }
    },
    ajax: {
      url: function(params) {
        return this.data('source');
      },
      dataType: 'json',
      delay: 250,
      processResults: function(data, params) {
        return {
          results: data
        }
      },
      data: function (params) {
        return {
          autocomplete: params.term,
          page: 1
        }
      },
    }
  });
})
