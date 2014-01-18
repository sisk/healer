require "v1/base_decorator"

class V1::TripDecorator < V1::BaseDecorator
  delegate :nickname

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

  def link
    "/v1/trips/#{model.nickname}"
  end

  def edit_link
    "/v1/trips/#{model.nickname}/edit"
  end

end