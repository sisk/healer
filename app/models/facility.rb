class Facility < ActiveRecord::Base
  validates_presence_of :name
  has_many :rooms, :dependent => :destroy
  
  def to_s
    name
  end
  
  def one_line_address
    str = [address1, address2, city, state, zip, country].reject{ |a| a.blank? }.join(", ")
    return str.blank? ? nil : str
  end
  
end
