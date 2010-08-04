class Trip < ActiveRecord::Base
  has_and_belongs_to_many :staff, :class_name => "User", :join_table => "staff_trips", :foreign_key => "staff_id"
  validates_presence_of :country, :message => "can't be blank"

  default_scope order(:start)
  
  scope :current, lambda {
    where("trips.start IS NOT NULL AND trips.start <= ? AND (trips.end IS NULL OR (trips.end IS NOT NULL AND trips.end > ?))", Time.zone.now, Time.zone.now)
  }
  scope :future, lambda {
    where("trips.start IS NULL OR (trips.start > ? AND (trips.end IS NULL OR trips.end > ?))", Time.zone.now, Time.zone.now)
  }
  scope :past, lambda {
    where("trips.end IS NOT NULL AND trips.end <= ?", Time.zone.now)
  }
  
  def to_s
    year = start.blank? ? "" : start.strftime("%Y")
    [year, country_name].join(" ").strip
  end
  
  def country_name
    Carmen::country_name(country)
  end

  def destination
    return [city, country_name].join(", ").strip unless city.blank?
    return country_name
  end
  
end

# == Schema Information
#
# Table name: trips
#
#  id         :integer(4)      not null, primary key
#  start      :date
#  end        :date
#  country    :string(255)     not null
#  city       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

