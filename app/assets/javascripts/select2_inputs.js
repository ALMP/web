$(document).on("turbolinks:load", function() {
  $(".select2").select2({
    theme: 'bootstrap',
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

  var flagSelection = function(state) {
    if (!state.element) {
      return state.text;
    }
    var icon = state.element.dataset.icon;
    var $state = $(
        '<span><img src="' + icon + '" class="img-flag" /></span>'
        );
    return $state;
  }

  $(".select2-lang").select2({
    theme: 'bootstrap',
    width: '100%',
    minimumResultsForSearch: Infinity,
    templateSelection: flagSelection,
    templateResult: flagSelection
  })
})
