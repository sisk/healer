class V1::BaseDecorator < Draper::Decorator

  private ######################################################################

  def spanish?
    I18n.locale == :es
  end

end