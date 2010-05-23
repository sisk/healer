class Trip < ActiveRecord::Base
  validates_presence_of :country, :on => :save, :message => "can't be blank"
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

