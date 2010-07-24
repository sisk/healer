class Implant < ActiveRecord::Base
  belongs_to :operation
  belongs_to :body_part
  validates_inclusion_of :side, :in => ["L", "R", nil]
end