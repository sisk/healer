require "v1/base_decorator"
require "v1/patient_case_decorator"

class V1::AppointmentDecorator < V1::BaseDecorator

  def title
    return I18n.t("anatomy.unspecified") if model.patient_cases.empty?

    if bilateral_all_revision? || !(any_revision? || !model.bilateral?)
      parts = [anatomy.titlecase]
      parts << I18n.t("revision").titlecase if bilateral_all_revision?
      parts << "(#{I18n.t("bilateral").titlecase})"
      parts.join(" ")
    else
      case_titles.join(", ")
    end
  end


  private ######################################################################

  def bilateral_all_revision?
    model.bilateral? && model.patient_cases.all?{ |pc| pc.revision? }
  end

  def any_revision?
    model.patient_cases.any?{ |pc| pc.revision? }
  end

  def case_titles
    model.patient_cases.map{ |pc| V1::PatientCaseDecorator.new(pc).title }
  end

  def anatomy
    # Note: this does not yet cover a case where body parts may be mixed.
    I18n.t("anatomy.#{model.anatomies.first}")
  end

end