class Implant < ActiveRecord::Base
  belongs_to :operation
  belongs_to :body_part

  def self.desired_attributes
    []
  end

  def attributes_complete?
    desired_attributes.all?{ |attr| self.send(attr).present? }
  end

end