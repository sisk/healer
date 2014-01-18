class V1::BaseDecorator < Draper::Decorator

  def dom_id
    h.dom_id(model)
  end

  private ######################################################################

  def spanish?
    I18n.locale == :es
  end

end