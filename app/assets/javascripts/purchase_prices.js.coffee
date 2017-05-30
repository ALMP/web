$(document).on 'turbolinks:load', ->
  $("#purchase_price_kind").on 'change', ->
    $unitSelect = $("#purchase_price_unit")
    $serviceOptionsElements = $("option[value='project'], option[value='day'], option[value='hour']", $unitSelect)

    if @value == 'goods'
      $("option", $unitSelect).not($serviceOptionsElements).show()
      $serviceOptionsElements.hide()
      $unitSelect.val('item') if $unitSelect.val() in ['project', 'day', 'hour']
    else
      $("option", $unitSelect).not($serviceOptionsElements).hide()
      $serviceOptionsElements.show()
      $unitSelect.val('project') unless $unitSelect.val() in ['project', 'day', 'hour']

  $("#purchase_price_kind").trigger 'change'
