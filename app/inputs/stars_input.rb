# frozen_string_literal: true
class StarsInput < SimpleForm::Inputs::NumericInput
  def input(wrapper_options = nil)
    input_html_classes.unshift('numeric')
    if html5?
      input_html_options[:type] ||= 'number'
      input_html_options[:step] ||= integer? ? 1 : 'any'
    end

    id = "stars_#{attribute_name}"
    input_html_options[:id] = id

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:required] = false
    out = @builder.text_field(attribute_name, merged_input_options.merge(class: 'd-none'))
    score = object.public_send(attribute_name) || 0
    out << content_tag(:div, nil, data: { score: score, target: "##{id}" }, class: 'stars-input text-warning')

    out
  end
end
