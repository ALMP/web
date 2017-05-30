$(document).on 'turbolinks:load', ->
  companiesSource = new Bloodhound
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    datumTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/api/v1/companies?autocomplete=%QUERY'
      wildcard: '%QUERY'

  $(".typeahead#review_company_name, .typeahead#purchase_price_company_name").typeahead
     minLength: 2
   ,
     name: 'companies-source'
     display: 'name'
     source: companiesSource
