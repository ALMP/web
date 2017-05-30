submitForm = ($form) ->
  valid = true
  $("input", $form).each (index, input) ->
    console.log(input)
    unless input.checkValidity()
      valid = false
      input.reportValidity()
      return false
  $form.submit() if valid

$(document).on 'click', '.form-submit', -> submitForm $(@).closest('form')
$(document).on 'keypress', 'input', (event) ->
  submitForm @form  if (event.which == 10 || event.which == 13)
$(document).on 'keydown', ->
  minchars = 50
  lang = $('html').attr('lang')
  if lang=='ru'
    dynamic_length =" осталось ввести"
    max_length ="Введено количество минимальных символов"
  else if lang=='en'
    dynamic_length =" left to enter"
    max_length ="Entered the number of minimum characters"
  else if lang=='zh-CN'
    dynamic_length =" 離開進入"
    max_length= "輸入文件的最少字符數"
  advantages_id= 'review_advantages'
  disadvantages_id='review_disadvantages'
  $('textarea').keydown ->
    number = $('textarea[id=\''+advantages_id+'\']').click().val().length
    text=$('small:first').closest('.help-block')
    if $(this).attr('id')==disadvantages_id
      number = $('textarea[id=\''+disadvantages_id+'\']').val().length
      text=$('small:eq(1)').closest('.help-block')
    if number < minchars
      text.html minchars - number + dynamic_length
    else
      text.html max_length