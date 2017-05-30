$(document).on 'turbolinks:load', ->
  citiesSource = new Bloodhound
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    datumTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/api/v1/cities?autocomplete=%QUERY'
      wildcard: '%QUERY'

  categoriesSource = new Bloodhound
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    datumTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/api/v1/categories?autocomplete=%QUERY'
      wildcard: '%QUERY'

  goodsSource = new Bloodhound
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    datumTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/api/v1/goods?autocomplete=%QUERY'
      wildcard: '%QUERY'

  $(".typeahead#search_city").typeahead
     minLength: 2
   ,
     name: 'cities-source'
     display: 'name'
     source: citiesSource

  $(".typeahead#search_category").typeahead
     minLength: 2
   ,
     name: 'categories-source'
     display: 'name'
     source: categoriesSource

  $(".typeahead#search_good").typeahead
     minLength: 2
   ,
     name: 'goods-source'
     display: 'name'
     source: goodsSource
