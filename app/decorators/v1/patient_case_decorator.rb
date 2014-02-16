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

  def patient
    model.patient.name_full
  end

  def procedure
    return nil unless model.operation
    return unspecified_operation_message unless procedure = model.operation.procedure

    if I18n.locale == :es
      procedure.name_es || procedure.name_en
    else
      procedure.name_en
    end
  end

  def operation_date
    return nil unless model.operation
    return unspecified_date_message unless date = model.operation.date

    if I18n.locale == :es
      date.to_formatted_s(:short_spanish)
    else
      date.to_formatted_s(:short_english)
    end
  end

  def xrays(opts = {})
    set = all_xrays
    set = set & primary_xrays if opts[:primary]
    set = set & pre_op_xrays if opts[:pre_op]
    set = set & post_op_xrays if opts[:post_op]
    set
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

  def unspecified_operation_message
    "[#{I18n.t("unspecified_operation")}]"
  end

  def unspecified_date_message
    "[#{I18n.t("unspecified_date")}]"
  end

  def all_xrays
    @all_xrays ||= model.xrays
  end

  def primary_xrays
    @primary_xrays ||= all_xrays.select{ |x| x.primary == true }
  end

  def post_op_xrays
    @post_op_xrays ||= all_xrays.select{ |x| x.operation_id.present? }
  end

  def pre_op_xrays
    @pre_op_xrays ||= all_xrays.select{ |x| x.operation_id.nil? }
  end

end