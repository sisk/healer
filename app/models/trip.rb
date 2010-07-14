class Trip < ActiveRecord::Base
  validates_presence_of :country, :message => "can't be blank"
  
  def to_s
    year = start.blank? ? "" : start.strftime("%Y")
    [year, country_name].join(" ").strip
  end
  
  def country_name
    Carmen::country_name(country)
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

