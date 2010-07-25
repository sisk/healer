class Symptom < ActiveRecord::Base
  validates_presence_of :description
  def to_s
    description
  end
end
