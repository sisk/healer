class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input
    template.content_tag(:div, super)
  end
end