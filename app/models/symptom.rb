class Symptom < ActiveRecord::Base
  validates_presence_of :description
  has_and_belongs_to_many :follow_ups
  def to_s
    description
  end
end
