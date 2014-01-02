class V1::PatientDecorator < Draper::Decorator

  def name
    model.name_full
  end

  def first_name
    model.name_full.split(" ").first
  end

end