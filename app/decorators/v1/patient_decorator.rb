require "v1/base_decorator"

class V1::PatientDecorator < V1::BaseDecorator

  def name
    model.name_full
  end

  def first_name
    model.name_full.split(" ").first
  end

end