require "v1/base_decorator"

class V1::PatientCaseDecorator < V1::BaseDecorator

  def title
    return I18n.t("anatomy.unspecified") unless model.anatomy

    parts = []
    parts << anatomy_short.titlecase
    parts << I18n.t("revision").titlecase if model.revision?
    parts << side_abbr

    parts.compact.join(" ")
  end

  def anatomy
    return I18n.t("anatomy.unspecified") unless model.anatomy

    [anatomy_short.titlecase, side_abbr].compact.join(" ")
  end


  private ######################################################################

  def anatomy_short
    I18n.t("anatomy.#{model.anatomy}")
  end

  def side_abbr
    "(#{I18n.t("#{model.side}")[0].upcase})" if model.side
  end

  def side_full
    I18n.t("#{model.side}")
  end

end