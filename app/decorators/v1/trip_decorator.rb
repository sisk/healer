require "v1/base_decorator"

class V1::TripDecorator < V1::BaseDecorator

  def name
    year = model.start_date.blank? ? "" : model.start_date.strftime("%Y")
    [year, country].join(" ").strip
  end

  def destination
    [model.city, country].reject{ |v| v.blank? }.join(", ").strip
  end

  def country
    Carmen::Country.coded(model.country).name
  end

end